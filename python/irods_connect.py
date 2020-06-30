import os
import ssl
from irods.session import iRODSSession

def create_irods_session():
    """<definition>

    Parameters
    ----------
    name : type
        <definition>
    """
    try:
        env_file = os.environ['IRODS_ENVIRONMENT_FILE']
    except KeyError:
        env_file = os.path.expanduser('~/.irods/irods_environment.json')

    ssl_context = ssl.create_default_context(purpose=ssl.Purpose.SERVER_AUTH, cafile=None, capath=None, cadata=None)
    ssl_settings = {'ssl_context': ssl_context}
    with iRODSSession(irods_env_file=env_file, **ssl_settings) as session:
        pass
    
    return session
