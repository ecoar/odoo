FROM odoo:11

ENV \
  ODOO_CONNECTOR_CHANNELS=root:3,root.prestashop:1 \
  ODOO_MAX_WORKERS=3 \
  ODOO_DATABASE_FILTER=Ecoar

USER root

# # WKHTMLTOPDF must be 0.12.1, which is a pain to install.
# RUN apt-get remove -y --purge wkhtmltox && \
#     apt-get update && apt-get install --no-install-recommends wget && \
#     cd /tmp && \
#     wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb && \
#     wget https://debian.sipwise.com/debian-security/pool/main/libp/libpng/libpng12-0_1.2.49-1+deb7u2_amd64.deb && \
#     wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb && \
#     dpkg -i libssl1.0.0_1.0.1t-1+deb8u11_amd64.deb && \
#     dpkg -i libpng12-0_1.2.49-1+deb7u2_amd64.deb && \
#     dpkg -i wkhtmltox-0.12.2.1_linux-jessie-amd64.deb && \
#     apt-get install -f && \
#     cp /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage && \
#     cp /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf && \
#     rm -rf /var/lib/apt/lists/*
# #     apt-get -qfy install ./wkhtmltox-0.12.1_linux-wheezy-amd64.deb && \
# #     wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.1/wkhtmltox-0.12.1_linux-wheezy-amd64.deb && \
# #     apt-get -fy install && \

RUN pip3 install wheel    
RUN pip3 install geocoder wkhtmltopdf phonenumbers python-cas pycryptodome odfpy xlrd

# For PrestaShop
# Working version of prestapyt
# TODO: use local file?
COPY ./prestapyt-migration-py3.zip prestapyt-migration-py3.zip
RUN pip3 install prestapyt-migration-py3.zip
RUN pip3 install freezegun vcrpy "cachetools<3.0.0" html2text bs4 --no-cache

USER odoo
# CMD odoo --load=web,web_kanban_gauge,base_sparse_field,connector,queue_job --workers $ODOO_MAX_WORKERS --database Ecoar
CMD odoo --load=web,web_kanban_gauge,base_sparse_field,connector,queue_job --workers $ODOO_MAX_WORKERS --db-filter "$ODOO_DATABASE_FILTER"
