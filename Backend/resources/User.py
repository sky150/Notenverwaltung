from flask_restful import Resource

class User(Resource):
    __tablename__ = 'users'

    id = db.Column(db.String(), primary_key=True, unique=True)
    username = db.Column(db.String(), primary_key=True)
    first_name = db.Column(db.String())
    last_name = db.Column(db.String())
    password = db.Column(db.String())
    email = db.Column(db.String())
    api_key = db.Column(db.String())


    def __init__(self, id,api_key,username,first_name,last_name,password, email):
        self.id = id
        self.api_key = api_key
        self.username = username
        self.first_name = first_name
        self.last_name = last_name
        self.password = password
        self.email = email

    def __repr__(self):
        return '<id {}>'.format(self.id)
    
    def serializer(self):
        return {
            'id' : self.id,
            'api_key' : self.api_key,
            'username' : self.username,
            'firstname' : self.firstname,
            'lastname' : self.lastname,
            'password' : self.password,
            'email' : self.email
        }
