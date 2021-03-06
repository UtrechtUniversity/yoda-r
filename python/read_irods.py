from irods.session import iRODSSession
import os
import ssl
from io import StringIO
import pandas as pd

def read_file(filename, data_path, separator):
    file_path = "/".join([data_path, filename])
    
    print("reading" + file_path)
    try:
        env_file = os.environ['IRODS_ENVIRONMENT_FILE']
    except KeyError:
        env_file = os.path.expanduser('~/.irods/irods_environment.json')

    ssl_context = ssl.create_default_context(purpose=ssl.Purpose.SERVER_AUTH, cafile=None, capath=None, cadata=None)
    ssl_settings = {'ssl_context': ssl_context}

    with iRODSSession(irods_env_file=env_file, **ssl_settings) as session:
        pass

    obj = session.data_objects.get(file_path)

    data = StringIO(obj.open().read().decode())

    return pd.read_csv(data, sep=separator)  

