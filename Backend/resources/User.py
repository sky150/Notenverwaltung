from flask_restful import Resource

class User(Resource):
    __tablename__ = 'users'

    id = db.Column(db.String(), primary_key=True, unique=True)
    username = db.Column(db.String(), primary_key=True)
    first_name = db.Column(db.String())
    last_name = db.Column(db.String())
    password = db.Column(db.String())
    email = db.Column(db.String())


    def __init__(self, id,apiKey,username,first_name,last_name,password, email):
        self.id = id
        self.apiKey = apiKey
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
            'apiKey' : self.apiKey,
            'username' : self.username,
            'first_name' : self.first_name,
            'last_name' : self.last_name,
            'password' : self.password,
            'email' : self.email
        }
