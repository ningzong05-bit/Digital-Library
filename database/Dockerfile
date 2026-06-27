FROM mysql:8.4

WORKDIR /import
COPY zsc_local_full_2026-06-27.sql /import/zsc_local_full_2026-06-27.sql
COPY import-railway.sh /import/import-railway.sh

CMD ["sh", "/import/import-railway.sh"]
