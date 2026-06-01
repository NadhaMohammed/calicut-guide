import os
from flask import Flask, render_template, request, session, g, redirect, url_for
import pymysql
from werkzeug.utils import secure_filename

# Attempt to load .env file if python-dotenv is installed
try:
    from dotenv import load_dotenv
    load_dotenv(os.path.join(os.path.dirname(os.path.abspath(__file__)), '.env'))
except ImportError:
    pass

app = Flask(__name__)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'change-this-to-a-secure-random-key-in-production')
os.makedirs(os.path.join(app.root_path, "static/image"), exist_ok=True)

def init_db():
    try:
        conn = pymysql.connect(
            host=os.environ.get('DB_HOST', 'localhost'),
            user=os.environ.get('DB_USER', 'root'),
            password=os.environ.get('DB_PASSWORD', 'root'),
            port=int(os.environ.get('DB_PORT', 3306)),
            db=os.environ.get('DB_NAME', 'calicut_website'),
            charset='utf8'
        )
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS admin_profile (
                id INT AUTO_INCREMENT PRIMARY KEY,
                login_id INT NOT NULL,
                full_name VARCHAR(100) DEFAULT '',
                email VARCHAR(100) DEFAULT '',
                phone VARCHAR(20) DEFAULT '',
                UNIQUE KEY uq_login (login_id)
            )
        """)
        migrate_contact_columns(cursor)
        migrate_vehicle_no_columns(cursor)
        migrate_facility_columns(cursor)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"DB init warning: {e}")

init_db()

CONTACT_COLUMN_MIGRATIONS = [
    ('shop_details', 'contact'),
    ('restaurant_details', 'contact'),
    ('education_details', 'contact'),
    ('doctor_details', 'contact'),
    ('ambulance_details', 'contact_no'),
    ('taxi_details', 'contact_no'),
    ('mall_details', 'contact'),
    ('hospital_details', 'contact'),
]

NUMERIC_DB_TYPES = frozenset({
    'int', 'bigint', 'mediumint', 'smallint', 'tinyint', 'decimal', 'float', 'double'
})

_contact_columns_migrated = False

def migrate_contact_columns(cursor):
    for table, column in CONTACT_COLUMN_MIGRATIONS:
        cursor.execute("""
            SELECT DATA_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = %s AND COLUMN_NAME = %s
        """, (table, column))
        row = cursor.fetchone()
        if row and row[0].lower() in NUMERIC_DB_TYPES:
            cursor.execute(f"ALTER TABLE `{table}` MODIFY `{column}` VARCHAR(20) NOT NULL")

def migrate_vehicle_no_columns(cursor):
    cursor.execute("""
        SELECT DATA_TYPE FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ambulance_details' AND COLUMN_NAME = 'vehicle_no'
    """)
    row = cursor.fetchone()
    if row and row[0].lower() in NUMERIC_DB_TYPES:
        cursor.execute("ALTER TABLE `ambulance_details` MODIFY `vehicle_no` VARCHAR(20) NOT NULL")

def migrate_facility_columns(cursor):
    for table, column in (
        ('ambulance_details', 'facility'),
        ('mall_details', 'facility'),
        ('beach_details', 'facility'),
    ):
        cursor.execute("""
            SELECT CHARACTER_MAXIMUM_LENGTH FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = %s AND COLUMN_NAME = %s
        """, (table, column))
        row = cursor.fetchone()
        if row and row[0] is not None and row[0] < 255:
            cursor.execute(f"ALTER TABLE `{table}` MODIFY `{column}` VARCHAR(255) NOT NULL")

def ensure_contact_columns_varchar():
    global _contact_columns_migrated
    if _contact_columns_migrated:
        return
    try:
        migrate_contact_columns(g.cmd)
        migrate_vehicle_no_columns(g.cmd)
        migrate_facility_columns(g.cmd)
        g.db.commit()
    except Exception as e:
        print(f"contact column migration warning: {e}")
    _contact_columns_migrated = True

def normalize_contact(value):
    if value is None:
        return None
    contact = str(value).strip()
    if not contact or not any(c.isdigit() for c in contact):
        return None
    return contact

def normalize_vehicle_no(value):
    if value is None:
        return None
    vehicle_no = str(value).strip().upper()
    return vehicle_no if vehicle_no else None

def format_ambulance_row(row):
    row = with_contact_as_string(row, 3)
    if row is None:
        return None
    row = list(row)
    if row[1] is not None:
        row[1] = str(row[1])
    return tuple(row)

def format_ambulance_rows(rows):
    return [format_ambulance_row(row) for row in rows]

def with_contact_as_string(row, contact_index):
    if row is None:
        return None
    row = list(row)
    if contact_index < len(row) and row[contact_index] is not None:
        row[contact_index] = str(row[contact_index])
    return tuple(row)

def with_contacts_as_strings(rows, contact_index):
    return [with_contact_as_string(row, contact_index) for row in rows]

def invalid_contact_response(redirect_url):
    return f'''<script>alert("Please enter a valid contact number");window.location='{redirect_url}'</script>'''

def login_required_redirect(redirect_url='/'):
    if not session.get('lid'):
        return f'''<script>alert("Please login first");window.location='{redirect_url}'</script>'''
    return None

def resolve_hospital_id():
    lid = session.get('lid')
    if not lid:
        return None
    g.cmd.execute("SELECT hospital_id FROM hospital_details WHERE login_id = %s", (lid,))
    row = g.cmd.fetchone()
    if row:
        return row[0]
    return lid

def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host=os.environ.get('DB_HOST', 'localhost'),
            user=os.environ.get('DB_USER', 'root'),
            password=os.environ.get('DB_PASSWORD', 'root'),
            port=int(os.environ.get('DB_PORT', 3306)),
            db=os.environ.get('DB_NAME', 'calicut_website'),
            charset='utf8'
        )
    return g.db

@app.before_request
def before_request():
    g.db = get_db()
    g.cmd = g.db.cursor()
    ensure_contact_columns_varchar()

@app.teardown_request
def teardown_request(exception):
    cmd = g.pop('cmd', None)
    if cmd is not None:
        cmd.close()
    db = g.pop('db', None)
    if db is not None:
        db.close()


@app.route('/')
def login():
    return render_template('login.html')


@app.route('/logincheck', methods=['post'])
def logincheck():
    user = request.form['username']
    psd = request.form['password']
    g.cmd.execute("select * from login where username = %s and password = %s", (user, psd))
    result = g.cmd.fetchone()
    if result is None:
        return '''<script>alert("INVALID USERNAME AND PASSWORD");window.location='/'</script>'''
    elif result[3] == 'admin':
        session['lid'] = result[0]
        return render_template('admin_homepage.html')
    elif result[3] == 'hospital':
        session['lid'] = result[0]
        return render_template('Hospital_Homepage.html')
    elif result[3] == 'ambulance':
        session['lid'] = result[0]
        return render_template('Hospital_Homepage.html')
    elif result[3] == 'restaurant':
        session['lid'] = result[0]
        return render_template('admin_restaurant_details_home.html')
    elif result[3] == 'Shop':
        session['lid'] = result[0]
        return render_template('admin_shop_homepage.html')
    elif result[3] == 'education':
        session['lid'] = result[0]
        return render_template('course_homepage.html')
    else:
        return '''<script>alert("Unknown user type");window.location='/'</script>'''




@app.route('/admin_profile')
def admin_profile():
    lid = session.get('lid')
    if not lid:
        return '''<script>window.location='/'</script>'''
    g.cmd.execute("SELECT username FROM login WHERE login_id = %s", (lid,))
    login_data = g.cmd.fetchone()
    g.cmd.execute("SELECT full_name, email, phone FROM admin_profile WHERE login_id = %s", (lid,))
    profile_data = g.cmd.fetchone()
    return render_template('admin_profile.html', login=login_data, profile=profile_data)


@app.route('/update_admin_profile', methods=['post'])
def update_admin_profile():
    lid = session.get('lid')
    if not lid:
        return '''<script>window.location='/'</script>'''
    full_name = request.form.get('full_name', '')
    email = request.form.get('email', '')
    phone = request.form.get('phone', '')
    username = request.form.get('username', '')
    new_password = request.form.get('new_password', '').strip()
    if new_password:
        g.cmd.execute("UPDATE login SET username=%s, password=%s WHERE login_id=%s", (username, new_password, lid))
    else:
        g.cmd.execute("UPDATE login SET username=%s WHERE login_id=%s", (username, lid))
    g.db.commit()
    g.cmd.execute("SELECT id FROM admin_profile WHERE login_id=%s", (lid,))
    existing = g.cmd.fetchone()
    if existing:
        g.cmd.execute(
            "UPDATE admin_profile SET full_name=%s, email=%s, phone=%s WHERE login_id=%s",
            (full_name, email, phone, lid))
    else:
        g.cmd.execute(
            "INSERT INTO admin_profile (login_id, full_name, email, phone) VALUES (%s, %s, %s, %s)",
            (lid, full_name, email, phone))
    g.db.commit()
    return '''<script>alert("Profile updated successfully");window.location='/admin_profile'</script>'''


@app.route('/hospital')
def hospital():
    g.cmd.execute("select * from hospital_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 5)
    return render_template('admin_hospital_registration.html', value=result)


@app.route('/hospital_registration', methods=['post'])
def hospital_registration():
    name = request.form['textfield']
    place = request.form["textfield2"]
    post = request.form["textfield3"]
    pin = request.form["textfield4"]
    contact = normalize_contact(request.form["textfield5"])
    if contact is None:
        return invalid_contact_response('/hospital')
    image = request.files["fileField"]
    img = secure_filename(image.filename)
    image.save(os.path.join(app.root_path, "static/image", img))
    email = request.form["email"]
    latitude = request.form["textfield6"]
    longitude = request.form["textfield7"]
    user = request.form["textfield8"]
    psd = request.form["password"]
    g.cmd.execute("insert into login values(null, %s, %s, 'hospital')", (user, psd))
    rid = g.cmd.lastrowid
    g.db.commit()
    g.cmd.execute(
        "insert into hospital_details values(null, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (name, place, post, pin, contact, img, email, latitude, longitude, str(rid)))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/hospital'</script>'''


@app.route('/delhospital')
def delhospital():
    did = request.args.get("id")
    g.cmd.execute("delete from hospital_details where hospital_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/hospital'</script>'''


@app.route('/edithospital')
def edithospital():
    eid = request.args.get("id")
    session['uid'] = eid
    g.cmd.execute("select * from hospital_details where hospital_id = %s", (eid,))
    result = with_contact_as_string(g.cmd.fetchone(), 5)
    return render_template('update_hospital.html', value=result)


@app.route('/update_hospital_details', methods=['post'])
def update_hospital_details():
    eid = session['uid']
    name = request.form['textfield']
    place = request.form["textfield2"]
    post = request.form["textfield3"]
    pincode = request.form["textfield4"]
    contact = normalize_contact(request.form["textfield5"])
    if contact is None:
        return invalid_contact_response('/hospital')
    latitude = request.form["textfield6"]
    longitude = request.form["textfield7"]
    email = request.form["email"]
    g.cmd.execute(
        "update hospital_details set name=%s, place=%s, post=%s, pincode=%s, contact=%s, latitude=%s, longitude=%s, email=%s where hospital_id=%s",
        (name, place, post, pincode, contact, latitude, longitude, email, eid))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/hospital'</script>'''


@app.route('/change_image')
def change_image():
    return render_template('change_img.html')


@app.route('/update_image', methods=['post'])
def update_image():
    eid = session['uid']
    image = request.files["fileField"]
    img = secure_filename(image.filename)
    image.save(os.path.join(app.root_path, "static/image", img))
    g.cmd.execute("update hospital_details set image = %s where hospital_id = %s", (img, eid))
    g.db.commit()
    return '''<script>alert("image updated successfully");window.location='/hospital'</script>'''


@app.route('/doctor_details')
def doctor_details():
    g.cmd.execute("select * from doctor_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 3)
    return render_template('Doctor_Details.html', value=result)



@app.route('/doctor_registration', methods=['post'])
def doctor_registration():
    name = request.form['textfield2']
    specialization = request.form['textfield']
    contact = normalize_contact(request.form['tel'])
    if contact is None:
        return invalid_contact_response('/doctor_details')
    hid = session['lid']
    g.cmd.execute("insert into doctor_details values(null, %s, %s, %s, %s)",
                (name, specialization, contact, str(hid)))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/doctor_details'</script>'''

@app.route('/deldoctor')
def deldoctor():
    did = request.args.get("id")
    g.cmd.execute("delete from doctor_details where doctor_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/doctor_details'</script>'''

@app.route('/editdoctor')
def editdoctor():
    eid = request.args.get("id")
    session['uid'] = eid
    g.cmd.execute("select * from doctor_details where doctor_id = %s", (eid,))
    result = with_contact_as_string(g.cmd.fetchone(), 3)
    return render_template('update_Doctor_Details.html', value=result)

@app.route('/update_doctordetails', methods=['post'])
def update_doctordetails():
    eid = session['uid']
    name = request.form['textfield2']
    specialization = request.form['textfield']
    contact = normalize_contact(request.form['tel'])
    if contact is None:
        return invalid_contact_response('/doctor_details')
    g.cmd.execute("update doctor_details set name=%s, specialization=%s, contact=%s where doctor_id=%s",
                (name, specialization, contact, eid))
    g.db.commit()
    return '''<script>alert(" successfully added");window.location='/doctor_details'</script>'''



@app.route('/ambulance_details')
def ambulance_details():
    auth = login_required_redirect()
    if auth:
        return auth
    g.cmd.execute("select * from ambulance_details")
    result = format_ambulance_rows(g.cmd.fetchall())
    return render_template('ambulance_details.html', value=result)



@app.route('/ambulance_registration', methods=['post'])
def ambulance_registration():
    auth = login_required_redirect('/ambulance_details')
    if auth:
        return auth
    vehicle_no = normalize_vehicle_no(request.form['number'])
    if vehicle_no is None:
        return '''<script>alert("Please enter a valid vehicle number");window.location='/ambulance_details'</script>'''
    contact_person = request.form['textfield']
    contact_no = normalize_contact(request.form['tel'])
    if contact_no is None:
        return invalid_contact_response('/ambulance_details')
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    hospital_id = resolve_hospital_id()
    g.cmd.execute("insert into ambulance_details values(null, %s, %s, %s, %s, %s)",
                (vehicle_no, contact_person, contact_no, facility, str(hospital_id)))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/ambulance_details'</script>'''

@app.route('/delambulance')
def delambulance():
    did = request.args.get("id")
    g.cmd.execute("delete from ambulance_details where ambulance_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/ambulance_details'</script>'''

@app.route('/editambulance')
def editambulance():
    eid = request.args.get("id")
    session['uid'] = eid
    g.cmd.execute("select * from ambulance_details where ambulance_id = %s", (eid,))
    result = format_ambulance_row(g.cmd.fetchone())
    return render_template('updateambulance_details.html', value=result)

@app.route('/update_ambulancedetails', methods=['post'])
def update_ambulancedetails():
    auth = login_required_redirect('/ambulance_details')
    if auth:
        return auth
    vehicle_no = normalize_vehicle_no(request.form['number'])
    if vehicle_no is None:
        return '''<script>alert("Please enter a valid vehicle number");window.location='/ambulance_details'</script>'''
    contact_person = request.form['textfield']
    contact_no = normalize_contact(request.form['tel'])
    if contact_no is None:
        return invalid_contact_response('/ambulance_details')
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    aid = session['uid']
    g.cmd.execute("update ambulance_details set vehicle_no=%s, name=%s, contact_no=%s, facility=%s where ambulance_id=%s",
                (vehicle_no, contact_person, contact_no, facility, str(aid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/ambulance_details'</script>'''



@app.route('/consultation')
def consultation():
    g.cmd.execute("select * from hospital_booking")
    result1 = g.cmd.fetchall()
    g.cmd.execute("select * from doctor_details")
    doc1 = g.cmd.fetchall()
    return render_template('Booking_Details.html', value=result1, doc=doc1)

@app.route('/add_consultation', methods=['post'])
def add_consultation():
    h_id = session['lid']
    name = request.form['select2']
    time = request.form['Booking_time']
    day = request.form['select']
    g.cmd.execute("insert into hospital_booking values(null, %s, %s, %s, %s)",
                (name, time, day, str(h_id)))
    g.db.commit()
    return '''<script>alert("Successfully added");window.location='/consultation'</script>'''


@app.route('/del_consultation')
def del_consultation():
    con_id = request.args.get("book_id")
    g.cmd.execute("delete from hospital_booking where book_id = %s", (str(con_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/consultation'</script>'''


@app.route('/edit_consultation')
def edit_consultation():
    cid = request.args.get('book_id')
    session['consult_id'] = cid
    g.cmd.execute("select * from hospital_booking where book_id = %s", (cid,))
    result = g.cmd.fetchone()
    g.cmd.execute("select * from doctor_details")
    doc1 = g.cmd.fetchall()
    return render_template("update_consultation.html", value=result, doc=doc1)


@app.route('/update_consultation', methods=['post'])
def update_consultation():
    consult_id = session['consult_id']
    time = request.form['Booking_time']
    day = request.form['select']
    g.cmd.execute("update hospital_booking set booking_time=%s, booking_day=%s where book_id = %s",
                (time, day, str(consult_id)))
    g.db.commit()
    return '''<script>alert("Successfully updated");window.location='/consultation'</script>'''


@app.route('/hospital_facility')
def hospital_facility():
    h_id = session['lid']
    g.cmd.execute("select * from hospital_facilities where hospital_id = %s", (str(h_id),))
    result = g.cmd.fetchall()
    return render_template('hospital_facilities.html', value=result)


@app.route('/add_hospital_facility', methods=['post'])
def add_hospital_facility():
    h_id = session['lid']
    facility = request.form['facility']
    description = request.form['description']
    g.cmd.execute("insert into hospital_facilities values(null, %s, %s, %s)",
                (facility, description, str(h_id)))
    g.db.commit()
    return '''<script>alert("Successfully Added");window.location='/hospital_facility'</script>'''



@app.route('/del_hospital_facility')
def del_hospital_facility():
    fac_id = request.args.get('facility_id')
    g.cmd.execute("delete from hospital_facilities where facility_id = %s", (fac_id,))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/hospital_facility'</script>'''



@app.route('/edit_hospital_facility')
def edit_hospital_facility():
    fac_id = request.args.get("facility_id")
    session['facility_id'] = fac_id
    g.cmd.execute("select * from hospital_facilities where facility_id = %s", (str(fac_id),))
    result1 = g.cmd.fetchone()
    return render_template('update_hospital_facilities.html', value=result1)


@app.route('/update_hospital_facility', methods=['post'])
def update_hospital_facility():
    fac_id = session['facility_id']
    facility = request.form['facility']
    description = request.form['description']
    g.cmd.execute("update hospital_facilities set name=%s, description=%s where facility_id=%s",
                (facility, description, str(fac_id)))
    g.db.commit()
    return '''<script>alert("Successfully Updated");window.location='/hospital_facility'</script>'''


@app.route('/transportation')
def transportation():
    return render_template('admin_transportation_homepage.html')

@app.route('/taxi_page_view')
def taxi_page_view():
    g.cmd.execute("select * from taxi_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 4)
    return render_template('taxi.html', value=result)

@app.route('/add_taxi', methods=['post'])
def add_taxi():
    taxi_type = request.form['type']
    place = request.form['place']
    contact_person = request.form['contact_person']
    contact_no = normalize_contact(request.form['contact_no'])
    if contact_no is None:
        return invalid_contact_response('/taxi_page_view')
    g.cmd.execute("insert into taxi_details values(null, %s, %s, %s, %s)",
                (taxi_type, place, contact_person, contact_no))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/taxi_page_view'</script>'''

@app.route('/deltaxi')
def deltaxi():
    did = request.args.get("taxi_id")
    g.cmd.execute("delete from taxi_details where taxi_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/transportation'</script>'''


@app.route('/edittaxi')
def edittaxi():
    eid = request.args.get("taxi_id")
    session['uid'] = eid
    g.cmd.execute("select * from taxi_details where taxi_id = %s", (eid,))
    result = with_contact_as_string(g.cmd.fetchone(), 4)
    return render_template('update_taxi.html', value=result)

@app.route('/update_taxi', methods=['post'])
def update_taxi():
    taxi_type = request.form['type']
    place = request.form['place']
    contact_person = request.form['contact_person']
    contact_no = normalize_contact(request.form['contact_no'])
    if contact_no is None:
        return invalid_contact_response('/taxi_page_view')
    tid = session['uid']
    g.cmd.execute("update taxi_details set type=%s, place=%s, contact_person=%s, contact_no=%s where taxi_id=%s",
                (taxi_type, place, contact_person, contact_no, str(tid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/transportation'</script>'''

@app.route('/bus_page_view')
def bus_page_view():
    g.cmd.execute("select * from bus_details")
    result = g.cmd.fetchall()
    return render_template('bus.html', value=result)

@app.route('/add_bus', methods=['post'])
def add_bus():
    bus_name = request.form['bus_name']
    latitude = request.form['latitude']
    longitude = request.form['longitude']

    g.cmd.execute("insert into bus_details values(null, %s, %s, %s)",
                (bus_name, latitude, longitude))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/bus_page_view'</script>'''

@app.route('/delbus')
def delbus():
    did = request.args.get("bus_id")
    g.cmd.execute("delete from bus_details where bus_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/transportation'</script>'''


@app.route('/editbus')
def editbus():
    eid = request.args.get("bus_id")
    session['uid'] = eid
    g.cmd.execute("select * from bus_details where bus_id = %s", (eid,))
    result = g.cmd.fetchone()
    return render_template('update_bus.html', value=result)

@app.route('/update_bus', methods=['post'])
def update_bus():
    bus_name = request.form['bus_name']
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    tid = session['uid']
    g.cmd.execute("update bus_details set bus_name=%s, latitude=%s, longitude=%s where bus_id=%s",
                (bus_name, latitude, longitude, str(tid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/transportation'</script>'''





@app.route('/railway_page_view')
def railway_page_view():
    g.cmd.execute("select * from railway_details")
    result = g.cmd.fetchall()
    return render_template('railway.html', value=result)

@app.route('/add_railway', methods=['post'])
def add_railway():
    name = request.form['name']
    about = request.form['about']

    latitude = request.form['latitude']
    longitude = request.form['longitude']

    g.cmd.execute("insert into railway_details values(null, %s, %s, %s, %s)",
                (name, about, latitude, longitude))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/railway_page_view'</script>'''

@app.route('/delrailway')
def delrailway():
    did = request.args.get("rail_id")
    g.cmd.execute("delete from railway_details where rail_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/transportation'</script>'''


@app.route('/editrailway')
def editrailway():
    eid = request.args.get("rail_id")
    session['uid'] = eid
    g.cmd.execute("select * from railway_details where rail_id = %s", (eid,))
    result = g.cmd.fetchone()
    return render_template('update_railway.html', value=result)

@app.route('/update_railway', methods=['post'])
def update_railway():
    name = request.form['name']
    about = request.form['about']
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    tid = session['uid']
    g.cmd.execute("update railway_details set name=%s, about=%s, latitude=%s, longitude=%s where rail_id=%s",
                (name, about, latitude, longitude, str(tid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/railway_page_view'</script>'''


@app.route('/Entertainment')
def Entertainment():
    return render_template('admin_entertainment_homepage.html')

@app.route('/beach_page_view')
def beach_page_view():
    g.cmd.execute("select * from beach_details")
    result = g.cmd.fetchall()
    return render_template('beach.html', value=result)


@app.route('/add_beach', methods=['post'])
def add_beach():
    name = request.form['name']
    place = request.form['place']
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    description = request.form['description']
    g.cmd.execute("insert into beach_details values(null, %s, %s, %s, %s, %s, %s)",
                (name, place, facility, latitude, longitude, description))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/beach_page_view'</script>'''


@app.route('/delbeach')
def delbeach():
    did = request.args.get("beach_id")
    g.cmd.execute("delete from beach_details where beach_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/Entertainment'</script>'''


@app.route('/editbeach')
def editbeach():
    eid = request.args.get("beach_id")
    session['uid'] = eid
    g.cmd.execute("select * from beach_details where beach_id = %s", (eid,))
    result = g.cmd.fetchone()
    return render_template('update_beach.html', value=result)

@app.route('/update_beach', methods=['post'])
def update_beach():
    name = request.form['name']
    place = request.form['place']
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    description = request.form['description']
    tid = session['uid']
    g.cmd.execute("update beach_details set name=%s, place=%s, facility=%s, latitude=%s, longitude=%s, description=%s where beach_id=%s",
                (name, place, facility, latitude, longitude, description, str(tid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/beach_page_view'</script>'''




@app.route('/mall_page_view')
def mall_page_view():
    g.cmd.execute("select mall_id, name, place, post, contact, facility, opens, closes, image from mall_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 4)
    return render_template('mall.html', value=result)

@app.route('/add_mall', methods=['post'])
def add_mall():
    name = request.form['name']
    place = request.form["place"]
    post = request.form["post"]
    contact = normalize_contact(request.form["contact"])
    if contact is None:
        return invalid_contact_response('/mall_page_view')
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    opens = request.form["opens"]
    closes = request.form["closes"]
    image = request.files["fileField"]
    img = secure_filename(image.filename)
    image.save(os.path.join(app.root_path, "static/image", img))
    g.cmd.execute(
        "insert into mall_details (name, place, post, contact, facility, opens, closes, image) values (%s, %s, %s, %s, %s, %s, %s, %s)",
        (name, place, post, contact, facility, opens, closes, img))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/mall_page_view'</script>'''

@app.route('/delmall')
def delmall():
    did = request.args.get("mall_id")
    g.cmd.execute("delete from mall_details where mall_id = %s", (did,))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/Entertainment'</script>'''


@app.route('/editmall')
def editmall():
    eid = request.args.get("mall_id")
    session['uid'] = eid
    g.cmd.execute("select mall_id, name, place, post, contact, facility, opens, closes, image from mall_details where mall_id = %s", (eid,))
    result = with_contact_as_string(g.cmd.fetchone(), 4)
    return render_template('update_mall.html', value=result)



@app.route('/update_mall', methods=['post'])
def update_mall():
    name = request.form['name']
    place = request.form["place"]
    post = request.form["post"]
    contact = normalize_contact(request.form["contact"])
    if contact is None:
        return invalid_contact_response('/mall_page_view')
    f1 = request.form.getlist('facilities')
    facility = ','.join(f1)
    opens = request.form["opens"]
    closes = request.form["closes"]
    tid = session['uid']
    g.cmd.execute("update mall_details set name=%s, place=%s, post=%s, contact=%s, facility=%s, opens=%s, closes=%s where mall_id=%s",
                (name, place, post, contact, facility, opens, closes, str(tid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/Entertainment'</script>'''


@app.route('/change_images')
def change_images():
    return render_template('change_img_mall.html')


@app.route('/update_images', methods=['post'])
def update_images():
    eid = session['uid']
    image = request.files["fileField"]
    img = secure_filename(image.filename)
    image.save(os.path.join(app.root_path, "static/image", img))
    g.cmd.execute("update mall_details set image = %s where mall_id = %s", (img, eid))
    g.db.commit()
    return '''<script>alert("image updated successfully");window.location='/Entertainment'</script>'''



@app.route('/Shop')
def Shop():
    return render_template('admin_shop_homepage.html')


@app.route('/shop_page_view')
def shop_page_view():
    return redirect(url_for('add_shop_page'))


@app.route('/add_shop_page')
def add_shop_page():
    g.cmd.execute("select * from shop_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 6)
    return render_template('add_shop.html', value=result)


@app.route('/add_shop', methods=['post'])
def add_shop():
    shop_type = request.form["shop_type"]
    name = request.form['name']
    place = request.form["place"]
    post = request.form["post"]
    pincode = request.form["pincode"]
    contactno = normalize_contact(request.form["contactno"])
    if contactno is None:
        return invalid_contact_response('/add_shop_page')
    opens = request.form["opens"]
    closes = request.form["closes"]
    user = request.form["username"]
    psd = request.form["password"]
    g.cmd.execute("insert into login values(null, %s, %s, 'Shop')", (user, psd))
    rid = g.cmd.lastrowid
    g.db.commit()
    g.cmd.execute(
        "insert into shop_details (shop_type, name, place, post, pincode, contact, opens, closes, login_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (shop_type, name, place, post, pincode, contactno, opens, closes, str(rid)))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/add_shop_page'</script>'''



@app.route('/delshop')
def delshop():
    did = request.args.get("shop_id")
    g.cmd.execute("delete from shop_details where shop_id = %s", (str(did),))
    g.db.commit()
    return '''<script>alert("deleted successfully");window.location='/add_shop_page'</script>'''


@app.route('/editshop')
def editshop():
    eid = request.args.get("shop_id")
    session['uid'] = eid
    g.cmd.execute("select * from shop_details where shop_id = %s", (str(eid),))
    result = with_contact_as_string(g.cmd.fetchone(), 6)
    return render_template('update_shop.html', value=result)


@app.route('/update_shop_details', methods=['post'])
def update_shop_details():
    eid = session['uid']
    shop_type = request.form['shop_type']
    name = request.form['name']
    place = request.form["place"]
    post = request.form["post"]
    pincode = request.form["pincode"]
    contactno = normalize_contact(request.form["contactno"])
    if contactno is None:
        return invalid_contact_response('/add_shop_page')
    opens = request.form["opens"]
    closes = request.form["closes"]
    g.cmd.execute(
        "update shop_details set shop_type=%s, name=%s, place=%s, post=%s, pincode=%s, contact=%s, opens=%s, closes=%s where shop_id=%s",
        (shop_type, name, place, post, pincode, contactno, opens, closes, str(eid)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/add_shop_page'</script>'''





@app.route('/restaurant')
def restaurant():
    g.cmd.execute("select * from restaurant_details")
    result = with_contacts_as_strings(g.cmd.fetchall(), 5)
    return render_template('add_view_restaurant.html', value=result)



@app.route('/reg_restaurant', methods=['post'])
def reg_restaurant():
    name = request.form['hotel_name']
    place = request.form['place']
    post = request.form['post']
    nearby = request.form['nearby']
    contact = normalize_contact(request.form['contact'])
    if contact is None:
        return invalid_contact_response('/restaurant')
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    username = request.form['username']
    password = request.form['password']
    fileField = request.files['images']
    fi = secure_filename(fileField.filename)
    fileField.save(os.path.join(app.root_path, "static/image", fi))
    g.cmd.execute("insert into login values(null, %s, %s, 'restaurant')", (username, password))
    g.db.commit()
    l_id = g.cmd.lastrowid
    g.cmd.execute(
        "insert into restaurant_details values(null, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (name, place, post, nearby, contact, latitude, longitude, fi, str(l_id)))
    g.db.commit()
    return '''<script>alert("Successfully Registered");window.location='/restaurant'</script>'''



@app.route('/del_restaurant')
def del_restaurant():
    res_id = request.args.get("id")
    g.cmd.execute("select login_id from restaurant_details where res_id = %s", (res_id,))
    l_id = g.cmd.fetchone()[0]
    g.cmd.execute("delete from restaurant_details where res_id = %s", (res_id,))
    g.db.commit()
    g.cmd.execute("delete from login where login_id = %s", (str(l_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/restaurant'</script>'''


@app.route('/edit_restaurant')
def edit_restaurant():
    res_id = request.args.get("id")
    session['res_id'] = res_id
    g.cmd.execute("select * from restaurant_details where res_id = %s", (res_id,))
    result = with_contact_as_string(g.cmd.fetchone(), 5)
    return render_template('update_restaurant.html', value=result)



@app.route("/update_restaurant", methods=["post"])
def update_restaurant():
    res_id = session['res_id']
    name = request.form['hotel_name']
    place = request.form['place']
    post = request.form['post']
    nearby = request.form['nearby']
    contact = normalize_contact(request.form['contact'])
    if contact is None:
        return invalid_contact_response('/restaurant')
    latitude = request.form['latitude']
    longitude = request.form['longitude']
    g.cmd.execute("update restaurant_details set name=%s, place=%s, post=%s, nearby=%s, contact=%s, latitude=%s, longitude=%s where res_id=%s",
                (name, place, post, nearby, contact, latitude, longitude, res_id))
    g.db.commit()
    return '''<script>alert("Successfully Registered");window.location='/restaurant'</script>'''



@app.route('/change_imgres')
def change_imgres():
    return render_template('change_imgres.html')

@app.route('/update_imgres', methods=['post'])
def update_imgres():
    ress_id = session['res_id']
    fileupload = request.files['images']
    fi = secure_filename(fileupload.filename)
    fileupload.save(os.path.join(app.root_path, "static/image", fi))
    g.cmd.execute("update restaurant_details set image = %s where res_id = %s", (fi, ress_id))
    g.db.commit()
    return '''<script>alert("image updated successfully");window.location='/restaurant'</script>'''


@app.route('/restaurant_details')
def restaurant_details():
    return render_template('admin_restaurant_details_home.html')


@app.route('/res_working')
def res_working():
    res_id = session['lid']
    g.cmd.execute("select * from login where login_id = %s", (str(res_id),))
    result1 = g.cmd.fetchone()
    g.cmd.execute("select * from res_workingtime where res_id = %s", (str(res_id),))
    result = g.cmd.fetchall()
    return render_template('add_view_restaurant_details.html', value1=result1, value=result)

@app.route('/reg_restime', methods=['post'])
def reg_restime():
    res_id = session['lid']

    mrn_hr = request.form['time']
    evg_hr = request.form['time2']
    g.cmd.execute("insert into res_workingtime values(null, %s, %s, %s)",
                (mrn_hr, evg_hr, str(res_id)))
    g.db.commit()
    return '''<script>alert("Successfully Added");window.location='/res_working'</script>'''



@app.route('/del_restime')
def del_restime():
    r_id = request.args.get('id')
    g.cmd.execute("delete from res_workingtime where id = %s", (str(r_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/res_working'</script>'''


@app.route('/edit_restime')
def edit_restime():
    t_id = request.args.get("id")
    session['t_id'] = t_id
    g.cmd.execute("select * from res_workingtime where id = %s", (str(t_id),))
    result = g.cmd.fetchone()
    return render_template('update_restaurant_details.html', value=result)


@app.route('/update_restime', methods=['post'])
def update_restime():
    t_id = session['t_id']
    mrn_hr = request.form['time']
    evg_hr = request.form['time2']
    g.cmd.execute("update res_workingtime set morning_hrs=%s, evng_hrs=%s where id=%s",
                (mrn_hr, evg_hr, str(t_id)))
    g.db.commit()
    return '''<script>alert("updated successfully");window.location='/res_working'</script>'''





@app.route('/res_room')
def res_room():
    g.cmd.execute("select * from res_room where res_id = %s", (session['res_id'],))
    result = g.cmd.fetchall()
    return render_template('add_view_room_details.html', value=result)



@app.route('/reg_restroom', methods=['post'])
def reg_restroom():
    t_id = session['res_id']
    room = request.form['room']
    occupancy = request.form['occupancy']
    price = request.form['price']
    roomamenities = request.form['roomamenities']
    file = request.files['image']
    fi = secure_filename(file.filename)
    file.save(os.path.join(app.root_path, "static/image", fi))
    g.cmd.execute("insert into res_room values(null, %s, %s, %s, %s, %s, %s)",
                (room, occupancy, price, roomamenities, fi, str(t_id)))
    g.db.commit()
    return '''<script>alert("Successfully Added");window.location='/res_room'</script>'''




@app.route('/del_resroom')
def del_resroom():
    r_id = request.args.get('id')
    g.cmd.execute("delete from res_room where id = %s", (str(r_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/res_room'</script>'''



@app.route('/edit_restroom')
def edit_restroom():
    r_id = request.args.get("id")
    session['r_id'] = r_id
    g.cmd.execute("select * from res_room where id = %s", (str(r_id),))
    result = g.cmd.fetchone()
    return render_template('update_restroom.html', value=result)

@app.route('/update_restroom', methods=['post'])
def update_restroom():
    v_id = session['r_id']
    room = request.form['room']
    occupancy = request.form['occupancy']
    price = request.form['price']
    roomamenities = request.form['roomamenities']
    g.cmd.execute("update res_room set room_details=%s, occupancy=%s, price=%s, room_des=%s where id=%s",
                (room, occupancy, price, roomamenities, str(v_id)))
    g.db.commit()
    return '''<script>alert("Successfully Updated");window.location='/res_room'</script>'''


@app.route('/edit_imgresroom')
def edit_imgresroom():
    return render_template('change_imgresroom.html')

@app.route('/update_imgroom', methods=['post'])
def update_imgroom():
    re_id = session['r_id']
    fileupload = request.files['image']
    fi = secure_filename(fileupload.filename)
    fileupload.save(os.path.join(app.root_path, "static/image", fi))
    g.cmd.execute("update res_room set photo = %s where id = %s", (fi, str(re_id)))
    g.db.commit()
    return '''<script>alert("Successfully updated");window.location='/res_room'</script>'''


@app.route('/res_menu')
def res_menu():
    g.cmd.execute("select * from res_food")
    result = g.cmd.fetchall()
    return render_template('add_view_foodmenu_details.html', value=result)


@app.route('/reg_restfood', methods=['post'])
def reg_restfood():
    rid = session['lid']
    price = request.form['price']
    dish = request.form['dish']
    category = request.form['category']
    veg = request.form['radio']
    non_veg = request.form['radio']

    g.cmd.execute("insert into res_food values(null, %s, %s, %s, %s, %s, %s)",
                (dish, category, veg, non_veg, price, str(rid)))
    g.db.commit()
    return '''<script>alert("Successfully Added");window.location='/res_menu'</script>'''


@app.route('/del_resfood')
def del_resfood():
    r_id = request.args.get('id')
    g.cmd.execute("delete from res_food where id = %s", (str(r_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/res_menu'</script>'''

@app.route('/edit_restfood')
def edit_restfood():
    r_id = request.args.get("id")
    session['r_id'] = r_id
    g.cmd.execute("select * from res_food where id = %s", (str(r_id),))
    result = g.cmd.fetchone()
    return render_template('update_restfood.html', value=result)


@app.route('/update_restfood', methods=['post'])
def update_restfood():
    v_id = session['r_id']
    price = request.form['price']
    dish = request.form['dish']
    category = request.form['category']
    veg = request.form['radio']
    non_veg = request.form['radio']
    g.cmd.execute("update res_food set dish=%s, category=%s, veg=%s, non_veg=%s, price=%s where id=%s",
                (dish, category, veg, non_veg, price, str(v_id)))
    g.db.commit()
    return '''<script>alert("Successfully Updated");window.location='/res_menu'</script>'''


@app.route('/education')
def education():
     g.cmd.execute("select * from education_details")
     result = with_contacts_as_strings(g.cmd.fetchall(), 5)
     return render_template('add_view_institution.html', value=result)



@app.route('/education_registration', methods=['post'])
def education_registration():

    name = request.form['name']
    place = request.form["place"]
    post = request.form["post"]
    pin = request.form["pin"]
    contact = normalize_contact(request.form["contact"])
    if contact is None:
        return invalid_contact_response('/education')
    email = request.form["email"]
    opens = request.form["opens"]
    closes = request.form["closes"]
    user = request.form["username"]
    psd = request.form["password"]
    g.cmd.execute("insert into login values(null, %s, %s, 'education')", (user, psd))
    rid = g.cmd.lastrowid
    g.db.commit()
    g.cmd.execute(
        "insert into education_details values(null, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (name, place, post, pin, contact, email, opens, closes, str(rid)))
    g.db.commit()
    return '''<script>alert("successfully registered");window.location='/education'</script>'''




@app.route('/del_education')
def del_education():
    e_id = request.args.get("id")
    g.cmd.execute("delete from education_details where edu_id = %s", (str(e_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/education'</script>'''


@app.route('/edit_education')
def edit_education():
    e_id = request.args.get("id")
    session['edu_id'] = e_id
    g.cmd.execute("select * from education_details where edu_id = %s", (str(e_id),))
    result = with_contact_as_string(g.cmd.fetchone(), 5)
    return render_template('update_institution.html', value=result)

@app.route('/update_education', methods=['post'])
def update_education():
    e_id = session['edu_id']
    name = request.form['name']
    place = request.form['place']
    post = request.form["post"]
    pin = request.form['pin']
    contact = normalize_contact(request.form['contact'])
    if contact is None:
        return invalid_contact_response('/education')
    email = request.form['email']
    opens = request.form['opens']
    closes = request.form['closes']
    g.cmd.execute("update education_details set name=%s, place=%s, post=%s, pincode=%s, contact=%s, email=%s, opens=%s, closes=%s where edu_id=%s",
                (name, place, post, pin, contact, email, opens, closes, str(e_id)))
    g.db.commit()
    return '''<script>alert("Successfully Updated");window.location='/education'</script>'''


@app.route('/course')
def course():

     return render_template('course_homepage.html')

@app.route('/add_course')
def add_course():
     g.cmd.execute("select * from add_course")
     result = g.cmd.fetchall()
     return render_template('add_view_course.html', value=result)


@app.route('/add_courses', methods=['post'])
def add_courses():
    e_id = session['lid']
    program = request.form['program']
    core_course = request.form['core_course']
    duration = request.form['duration']
    fees = request.form['fees']
    g.cmd.execute("insert into add_course values(null, %s, %s, %s, %s, %s)",
                (program, core_course, duration, fees, str(e_id)))
    g.db.commit()
    return '''<script>alert("Successfully Added");window.location='/add_course'</script>'''



@app.route('/del_course')
def del_course():
    e_id = request.args.get("id")
    g.cmd.execute("delete from add_course where id = %s", (str(e_id),))
    g.db.commit()
    return '''<script>alert("Successfully Deleted");window.location='/add_course'</script>'''



@app.route('/edit_course')
def edit_course():
    course_id = request.args.get("id")
    session['course_id'] = course_id
    g.cmd.execute("select * from add_course where id = %s", (course_id,))
    result = g.cmd.fetchone()
    return render_template('update_course.html', value=result)


@app.route('/update_course', methods=['post'])
def update_course():
    # program value in the select box
    c_id = session['course_id']
    program = request.form['program']
    core_course = request.form['core_course']
    duration = request.form['duration']
    fees = request.form['fees']
    g.cmd.execute("update add_course set program=%s, core_course=%s, course_duration=%s, fees=%s where id=%s",
                (program, core_course, duration, fees, str(c_id)))
    g.db.commit()
    return '''<script>alert("Successfully Updated");window.location='/education'</script>'''

if __name__ == '__main__':
    app.run(debug=True)
