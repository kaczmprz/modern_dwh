import random
import csv
import json
import logging
import boto3
from datetime import datetime
from time import sleep
from faker import Faker
from collections import namedtuple
from os.path import dirname, abspath, join

# create logger
logger = logging.getLogger('producer')
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

# create formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# add formatter to ch
ch.setFormatter(formatter)

# add ch to logger
logger.addHandler(ch)

fake = Faker('pl_PL')

Customer = namedtuple('Customer', 'name birth_date town email')
Product = namedtuple('Product', 'ean category net_price')
Shop = namedtuple('Shop', 'id city')
Order = namedtuple('Order', 'id datetime customer product shop')


def generate_customers(number: int):
    customers = [Customer(fake.name(), fake.date(end_datetime='-20y'), fake.city(), fake.free_email()) for _ in range(number)]
    logger.info('customers data generated')
    return customers


def generate_products(number: int):
    products = [Product(fake.ean8(), fake.pystr(min_chars=4, max_chars=4).upper(),
                        fake.pyfloat(positive=True, max_value=100, right_digits=2)) for _ in range(number)]
    logger.info('products data generated')
    return products


def generate_shops(number: int):
    shops = [Shop(id_+1, fake.city()) for id_ in range(number)]
    logger.info('shops data generated')
    return shops


def generate_orders(number: int, customers: list, products: list, shops: list):
    orders = [Order(id_+1, fake.date(end_datetime='-1y'), random.choice(customers).email,
                    random.choice(products).ean, random.choice(shops).id) for id_ in range(number)]
    logger.info('orders data generated')
    return orders


def write_to_csv(data, filename):
    list_ = [list(el) for el in data]
    dir_ = dirname(dirname(abspath(__file__)))
    path_file = join(join(dir_, 'data'), '{filename}.csv'.format(filename=filename))
    with open(path_file, 'w+', encoding='utf8', newline ='') as file:
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerows(list_)
    logger.info(f'{filename} data saved to csv file')
    return 0


def write_json(data, filename):
    list_ = [el._asdict() for el in data]
    dir_ = dirname(dirname(abspath(__file__)))
    path_file = join(join(dir_, 'data'), '{filename}.json'.format(filename=filename))
    with open(path_file, 'w', encoding='utf8') as file:
        json.dump(list_, file, ensure_ascii=False)
    logger.info(f'{filename} data saved to json file')
    return 0


def send_to_s3(filename, file_format):
    try:
        now = datetime.now()
        year, month, day = now.year, now.month, now.day
        now_ = datetime.now().strftime("%Y%m%d%H%M%S")
        s3 = boto3.client('s3')
        dir_ = dirname(dirname(abspath(__file__)))
        path_file = join(join(dir_, 'data'), '{filename}.{fileformat}'.format(filename=filename, fileformat=file_format))
        s3.upload_file(path_file, 'mdw-staging', '{filename}/{year}/{month}/{day}/{filename}_{now_}.{file_format}'.format(
            filename=filename, year=year, month=month, day=day, now_=now_, file_format=file_format))
        logger.info(f'{filename} data uploaded to s3 bucket')
        return 0
    except Exception as e:
        logger.warning('{e}'.format(e=e))


if __name__=="__main__":
    customers = generate_customers(200)
    products = generate_products(100)
    shops = generate_shops(15)
    write_to_csv(customers, 'customers')
    write_to_csv(products, 'products')
    write_to_csv(shops, 'shops')
    send_to_s3('customers', 'csv')
    send_to_s3('products', 'csv')
    send_to_s3('shops', 'csv')

    while True:
        orders = generate_orders(2000, customers, products, shops)
        write_json(orders, 'orders')
        send_to_s3('orders', 'json')
        sleep(4)