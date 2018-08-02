import os

e = os.environ

if __name__ == '__main__':
    print(e.get('WELCOME_STRING'))
