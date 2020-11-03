from flask_restful import Resource

class User(Resource):
    def get(self):
        return {"message": "Hello, Natalie!"}    
    def post(self):
        return {"message": "Hello, World!"}    
    def put(self):
        return {"message": "Hello, World!"}    
    def delete(self):
        return {"message": "Hello, World!"}