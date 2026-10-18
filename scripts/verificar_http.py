import urllib.request
import urllib.parse
import urllib.error
import http.cookiejar
import time
import os

base = os.environ.get('APP_TEST_URL', 'http://localhost:18080/biblioteca').rstrip('/')
client = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))

def request(path, fields=None):
    data = urllib.parse.urlencode(fields).encode() if fields is not None else None
    try:
        response = client.open(base+path, data)
    except urllib.error.HTTPError as error:
        response = error
    return response.status, response.read().decode('utf-8'), response.url

def check(condition, name):
    assert condition, name
    print('PASS:', name)

for path in ['/', '/libros', '/libros?accion=nuevo', '/estudiantes', '/estudiantes?accion=nuevo', '/prestamos', '/prestamos?accion=nuevo']:
    status, body, url = request(path)
    check(status == 200, 'GET '+path)

student = {'carnet': 'T'+str(int(time.time()))[-9:], 'nombreEstudiante': 'Prueba José <script>alert(1)</script>', 'carrera': 'Computación', 'telefono': '2222-3333'}
status, body, url = request('/estudiantes',student)
check(status == 200 and '/confirmacion' in url and '&lt;script&gt;' in body, 'Registrar estudiante, redirección y escape HTML')
status, body, url = request('/estudiantes',student)
check(status == 409 and 'Ya existe' in body and 'Computación' in body, 'Carné duplicado conserva formulario')
status, body, url = request('/estudiantes', {**student,'telefono':'abc'})
check(status == 400 and '8 dígitos' in body, 'Teléfono inválido')
status, body, url = request('/estudiantes', {**student,'nombreEstudiante':'  '})
check(status == 400, 'Nombre vacío')

book = {'titulo':'Prueba JDBC áéíóú', 'autor':'Autor de prueba', 'isbn':'TEST'+str(int(time.time())), 'idCategoria':'1','cantidadDisponible':'2'}
status, body, url = request('/libros',book)
check(status == 200 and '/confirmacion' in url and 'Prueba JDBC' in body, 'Registrar libro')
status, body, url = request('/libros',book)
check(status == 409 and 'Ya existe' in body, 'ISBN duplicado')
for value in ['-1','1.5','9999999999999999','abc']:
    status, body, url = request('/libros',{**book,'cantidadDisponible':value})
    check(status == 400, 'Cantidad inválida: '+value)
status, body, url = request('/libros',{**book,'idCategoria':'99999'})
check(status == 400 and 'categoría válida' in body, 'Categoría inexistente')
status, body, url = request('/libros',{**book,'isbn':'','cantidadDisponible':'0'})
check(status == 200, 'ISBN opcional y cantidad cero')
status, body, url = request('/libros',{**book,'isbn':''})
check(status == 200, 'Múltiples ISBN vacíos permitidos')
status, body, url = request('/prestamos', {'accion':'registrar'})
check(status == 405, 'Puente temporal no registra préstamos')
status, body, url = request('/libros')
check('Sin existencias' in body and 'Prueba JDBC' in body, 'Listado de libros y disponibilidad')
status, body, url = request('/estudiantes')
check('&lt;script&gt;' in body and '<script>alert(1)</script>' not in body, 'Listado de estudiantes escapa datos')
print('Todas las comprobaciones pasaron.')
