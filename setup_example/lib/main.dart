import 'dart:convert';

void main() {
  String jsonString = '''
  {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john.doe@example.com",
      "age": 30,
      "isActive": true,
      "registeredAt": "2023-05-15T10:30:00Z",
      "address": {
        "street": "123 Main St",
        "city": "New York",
        "country": "USA",
        "zipCode": "10001"
      },
      "phoneNumbers": [
        {
          "type": "home",
          "number": "212-555-1234"
        },
        {
          "type": "work",
          "number": "646-555-5678"
        }
      ],
      "preferences": {
        "newsletter": true,
        "darkMode": false
      },
      "tags": ["customer", "premium"]
    }
  }
  ''';

  Map<String, dynamic> data = jsonDecode( jsonString ); 
