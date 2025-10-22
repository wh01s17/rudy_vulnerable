# R.U.D.Y. Vulnerable Django App

> **⚠️ ¡ESTE PROYECTO ES INTENCIONALMENTE INSEGURO!**  
> Esta aplicación es **solamente** para fines educativos, pruebas en entornos controlados y con autorización explícita. No uses este proyecto contra sistemas que no sean de tu propiedad o sin permiso expreso. **El autor no se hace responsable del uso indebido**.

---

## Descripción
Proyecto Django intencionalmente vulnerable a ataques tipo **R.U.D.Y. (R-U-Dead-Yet?)**. El propósito es demostrar cómo funcionan estos ataques en un entorno controlado y servir como base para ejercicios y análisis.

El repositorio contiene:
- Una aplicación vulnerable con endpoints para `form` y `upload`.
- `rudy_attack.sh`: script de ejemplo que usa `slowhttptest` para simular conexiones lentas y ataques R.U.D.Y.


## Endpoints
- `GET /` — página principal (`home.html`).
- `GET|POST /form/` — `vulnerable_form` (formulario con campo de texto grande, `@csrf_exempt`).
- `GET|POST /upload/` — `upload_endpoint` (acepta subidas y lee el archivo en memoria).


## Requisitos
- Python 3.10+ (o versión compatible).
- Django.
- Para las pruebas (opcional, sólo en entorno controlado):
  - `slowhttptest` (para simular conexiones lentas).
  - `netstat` o `ss` para monitoreo de conexiones.


## Instalación y ejecución (entorno local)
```bash
# clona el repo y ve al directorio del proyecto
git clone https://github.com/wh01s17/rudy_vulnerable
cd rudy_vulnerable

# crea y activa un virtualenv
python -m venv .venv
source .venv/bin/activate

# instala Django
pip install django

# aplica migraciones básicas
python manage.py migrate

# ejecuta el servidor
python manage.py runserver 0.0.0.0:8000
```


## Uso de rudy_attack.sh (demostración)

```bash
# dar permisos al script
chmod +x rudy_attack.sh

# ejemplo: atacar el servidor local durante 600 segundos (10 minutos)
./rudy_attack.sh http://127.0.0.1:8000 600
```

El script:

- Lanza varias instancias de slowhttptest con perfiles distintos contra /form/ y /upload/.

- Crea un directorio de salida ./rudy_<TARGET>_YYYYMMDD_HHMMSS con logs y PIDs.

- Monitorea conexiones activas (usa netstat buscando el puerto 8000).
