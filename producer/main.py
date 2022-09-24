import random
import csv
import json
from faker import Faker
from collections import namedtuple
from os.path import dirname, abspath, join

fake = Faker('pl_PL')

Customer = namedtuple('Customer', 'name birth_date town email')
Product = namedtuple('Product', 'ean category net_price')
Shop = namedtuple('Shop', 'id city')
Order = namedtuple('Order', 'id datetime customer product shop')


def generate_customers(number):
    customers = [Customer(fake.name(), fake.date(end_datetime='-20y'), fake.city(), fake.free_email()) for _ in range(number)]
    return customers


def generate_products(number):
    products = [Product(fake.ean8(), fake.pystr(min_chars=4, max_chars=4).upper(),
                        fake.pyfloat(positive=True, max_value=100, right_digits=2)) for _ in range(number)]
    return products


def generate_shops(number):
    shops = [Shop(id_+1, fake.city()) for id_ in range(number)]
    return shops


def generate_orders(number):
    customers = generate_customers(200)
    products = generate_products(100)
    shops = generate_shops(15)
    orders = [Order(id_+1, fake.date(end_datetime='-1y'), random.choice(customers).email,
                    random.choice(products).ean, random.choice(shops).id) for id_ in range(number)]
    return customers, products, shops, orders


def write_to_csv(data, filename):
    list_ = [list(el) for el in data]
    dir_ = dirname(dirname(abspath(__file__)))
    path_file = join(join(dir_, 'data'), '{filename}.csv'.format(filename=filename))
    with open(path_file, 'w+', encoding='utf8', newline ='') as file:
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerows(list_)
    return 0


def write_json(data, filename):
    list_ = [el._asdict() for el in data]
    dir_ = dirname(dirname(abspath(__file__)))
    path_file = join(join(dir_, 'data'), '{filename}.json'.format(filename=filename))
    with open(path_file, 'w', encoding='utf8') as file:
        json.dump(list_, file, ensure_ascii=False)
    return 0


def send_to_s3():
    pass


if __name__=="__main__":
    customers, products, shops, orders = generate_orders(200)
    write_to_csv(customers, 'customers')
    write_to_csv(products, 'products')
    write_to_csv(shops, 'shops')
    write_json(orders, 'orders')
    write_json(shops, 'shops')