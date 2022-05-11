FROM odoo:13

ENV \
  ODOO_CONNECTOR_CHANNELS=root:3,root.prestashop:1 \
  ODOO_MAX_WORKERS=3 \
  ODOO_DATABASE_FILTER=Ecoar

USER root

RUN pip3 install wheel geocoder wkhtmltopdf phonenumbers python-cas pycryptodome odfpy xlrd
RUN pip3 install --upgrade python-dateutil

# For PrestaShop
# Working version of prestapyt
COPY ./prestapyt-migration-py3.zip prestapyt-migration-py3.zip
RUN pip3 install prestapyt-migration-py3.zip

# Some packages need to be compiled it seems
# RUN apt-get update && apt-get install -y python3-dev build-essential \
#     && rm -rf /var/lib/apt/lists/* wkhtmltox.deb
RUN pip3 install freezegun vcrpy cachetools html2text bs4 --no-cache

# Debugpy for debugging
RUN pip3 install -U debugpy

USER odoo
# CMD odoo --load=web,web_kanban_gauge,base_sparse_field,connector,queue_job --workers $ODOO_MAX_WORKERS --database Ecoar
CMD odoo --load=web,web_kanban_gauge,base_sparse_field,connector,queue_job --workers $ODOO_MAX_WORKERS --db-filter "$ODOO_DATABASE_FILTER"
