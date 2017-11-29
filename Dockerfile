FROM odoo:11

RUN pip3 install geocoder --no-cache

CMD odoo -u all
