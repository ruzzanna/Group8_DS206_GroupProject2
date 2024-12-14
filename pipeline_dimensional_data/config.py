import configparser


def get_database_config(config_path='sql_server_config.cfg'):
    config = configparser.ConfigParser()
    config.read(config_path)

    db_config = {
        'server': config['database']['server'],
        'database': config['database']['database'],
        'username': config['database']['username'],
        'password': config['database']['password'],
        'driver': config['database']['driver']
    }
    return db_config
