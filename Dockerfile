FROM odoo:11

USER root
RUN pip3 install geocoder --no-cache

USER odoo
CMD odoo -u all
