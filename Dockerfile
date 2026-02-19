FROM searxng/searxng:latest

# カスタム設定ファイルをコンテナ内にコピー
COPY ./searxng/settings.yml /etc/searxng/settings.yml
COPY ./searxng/templates/simple/result_templates/images.html /usr/local/searxng/searx/templates/simple/result_templates/images.html

# 必要であればここで追加の静的ファイル（ロゴ、CSSなど）をコピーして上書き
# COPY ./static/css/ /usr/local/searxng/searx/static/themes/simple/css/
