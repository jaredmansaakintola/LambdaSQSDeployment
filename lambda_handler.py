import json

def is_a_queue(event):
    return not bool(event.get('Records'))


def read_queue(event):
    records = []
    for record in event.get('Records', []):
        records.append(json.loads(record.get('body')))

    return records

def lambda_handler(event, context):
    if is_a_queue(event):
        records = read_queue(event)
    else:
        records = [event]
<<<<<<< HEAD

    for item in records:
        print('hello: ' + item.get('key1'))

=======
        
    for item in records:
        print('hello: ' + item.get('key1'))
        
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f
    return {
        'statusCode': 200,
        'body': str(len(records)) + ' processed'
    }
