import csv
from os import path

def read_csv(file, columns = []):
    def fmt(x, x_type):
        if x_type == 'String':
            x = '"' + x + '"'
            
        return x
    
    basepath = path.dirname(__file__)
    filepath = path.abspath(path.join(basepath, '..', 'content', file + '.csv'))
    
    content_csv = []
    
    with open(filepath) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        if columns:
            cols = {}
            count_lines = 0
            for row in csv_reader:
                new_row = []
                for col in range(len(row)):
                    if count_lines == 0:
                        if row[col] in columns:
                            new_row.append(columns.get(row[col])['name'])
                            cols[col] = columns.get(row[col])['type']
                    else:
                        if col in cols:
                            new_row.append(fmt(row[col], cols[col]))
                
                content_csv.append(new_row)
                count_lines += 1
        else:
            for row in csv_reader:
                content_csv.append(row)
    
    return content_csv
            
def get_inserts(table, data):
    def generate_insert(table, fields, values):
        return 'INSERT INTO ' + table + '(' + fields + ') VALUES (' + values + ')' 

    inserts = []

    fields = (', '.join(data[0]))
    for i in range(1, len(data)):
        values = (', '.join(data[i]))
        inserts.append(generate_insert(table, fields, values))
    
    return inserts

def ibge_cities():
    table = 'cidade'
    columns = {'Código IBGE do Município': { 'name': 'cod_municipio', 'type': 'String' },
                    'Nome do Município': { 'name': 'municipio', 'type': 'String' },
                    'Código IBGE da Mesoregião': { 'name': 'cod_mesoregiao', 'type': 'String' },
                    'Nome da Mesoregião': { 'name': 'mesoregiao', 'type': 'String' },
                    'Código IBGE da Microregião': { 'name': 'cod_microregiao', 'type': 'String' },
                    'Nome da Microregião': { 'name': 'microregiao', 'type': 'String' },
                    'População residente': { 'name': 'populacao', 'type': 'Integer' },
                    'População residente rural': { 'name': 'pop_rural', 'type': 'Integer' },
                    'População residente urbana': { 'name': 'pop_urbana', 'type': 'Integer' },
                    'Homens': { 'name': 'pop_homens', 'type': 'Integer' },
                    'Mulheres': { 'name': 'pop_mulheres', 'type': 'Integer' }}
    
    data = read_csv('ibge_cities', columns)
    inserts = get_inserts(table, data)
    
    return inserts


def write_file_sql(data):
    basepath = path.dirname(__file__)
    filepath = path.abspath(path.join(basepath, '..', 'sql', 'inserts.sql'))
    
    with open(filepath, "w+") as sql_file:
        for item in data:
            sql_file.write("%s\n" % item)

def generate():
    all_insert_funcs = ['ibge_cities']
    
    for it in all_insert_funcs:
        write_file_sql(globals()[it]())


generate()