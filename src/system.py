import subprocess

def run(command):
    '''Execute a command in the shell environment'''
    result = subprocess.run(command, capture_output=True, shell=True, check=False)

    return (
        result.returncode,
        (result.stdout or result.stderr).decode('utf-8').rstrip()
    )
