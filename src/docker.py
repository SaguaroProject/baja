'''Helpers to abstract the Docker CLI'''

def exec(container: str, command: list, extras: list = []) -> str:
    '''docker exec <container> <command> [...extras]'''
    return "docker exec " + container + " " + " ".join(command + extras)
