create table coupon
(
    id   int unsigned auto_increment
        primary key,
    name varchar(32) not null comment 'クーポン名'
)
    comment 'クーポン';

create table customer_creditcard
(
    id                   int unsigned auto_increment
        primary key,
    customer_id          mediumint unsigned not null comment '顧客ID',
    card_number          varchar(16)        not null comment 'カード番号(ハイフンなし)',
    card_name            varchar(20)        not null comment 'カード名義人',
    card_expire_month    decimal(2)         not null comment 'カード利用期限(月)',
    card_expire_year     decimal(5)         not null comment 'カード利用期限(年)',
    card_security_number decimal(3)         not null comment 'セキュリティ番号'
)
    comment '顧客が持つクレジットカード情報';

create table item_kind
(
    id         mediumint unsigned auto_increment
        primary key,
    name       varchar(16)        not null comment 'カテゴリー名',
    parent     mediumint unsigned null comment '親カテゴリー',
    is_limited tinyint(1)         null comment '購入を制限する(ex.未成年者が買えないようにする)',
    created_at datetime           null comment '作成日時',
    updated_at datetime           not null comment '更新日時',
    deleted_at datetime           null comment '削除日時'
)
    comment '商品のカテゴリ';

create table payment_method
(
    id   tinyint unsigned auto_increment
        primary key,
    name varchar(8) null comment '決済方法'
)
    comment '決済方法';

create table payment_status
(
    id     int unsigned auto_increment
        primary key,
    status varchar(16) not null comment '決済ステータス'
);

create table orders
(
    id                int unsigned auto_increment
        primary key,
    customer_id       mediumint unsigned not null comment '顧客ID(注文してくれたお客さんを特定)',
    payment_status_id int unsigned       not null comment '決済ステータスID',
    total_price       int unsigned       not null comment '請求金額',
    delivery_usage    tinyint unsigned   not null comment '配送方法',
    created_at        datetime           null comment '作成日時',
    updated_at        datetime           not null comment '更新日時',
    deleted_at        datetime           null comment '削除日時',
    constraint orders_payment_status_id_fk
        foreign key (payment_status_id) references payment_status (id)
);

create table orders_price_detail
(
    id              int unsigned auto_increment
        primary key,
    order_id        int unsigned       not null comment '注文番号',
    tax_id          tinyint unsigned   not null comment '適用税率(taxテーブルを参照)',
    total_price     int unsigned       not null comment '適用税率ごとの合計金額',
    consumption_tax mediumint unsigned null comment '適用税率ごとの消費税の合計',
    constraint orders_price_detail_pk2
        unique (order_id, tax_id),
    constraint orders_price_detail_orders_id_fk
        foreign key (order_id) references orders (id)
);

create table payment_detail
(
    id                  mediumint unsigned auto_increment
        primary key,
    order_id            int unsigned     not null comment '注文番号',
    payment_method      tinyint unsigned not null comment '決済方法',
    customer_creditcard int unsigned     not null,
    constraint payment_detail_customer_creditcard_id_fk
        foreign key (customer_creditcard) references customer_creditcard (id),
    constraint payment_detail_orders_id_fk
        foreign key (order_id) references orders (id),
    constraint payment_detail_payment_method_id_fk
        foreign key (payment_method) references payment_method (id)
)
    comment '決済情報の詳細を格納(クレジットカード情報など)';

create table prefecture
(
    code   tinyint unsigned not null comment '都道府県コード'
        primary key,
    name   varchar(4)       not null comment '都道府県名',
    ei_mei varchar(16)      not null comment '英語名'
)
    comment '都道府県コードを管理';

create table customers
(
    id         mediumint unsigned auto_increment
        primary key,
    name       varchar(64)      null comment '氏名',
    first_name varchar(64)      null comment '名前',
    last_name  varchar(64)      null comment '姓',
    zip_code   varchar(7)       null comment '郵便番号(ハイフンなし)',
    province   tinyint unsigned null comment '都道府県コード',
    city       varchar(128)     null comment '町名',
    address1   varchar(128)     null comment '番地',
    address2   varchar(128)     null comment '番地以降(ビル・アパート名など)',
    tel        varchar(16)      null comment '電話番号(-ハイフンなし)',
    constraint customers_prefecture_code_fk
        foreign key (province) references prefecture (code)
)
    comment '顧客(注文した人の情報を管理)';

create table tax
(
    id         tinyint unsigned auto_increment
        primary key,
    rate       float unsigned not null comment '税率',
    start      datetime       not null comment '開始',
    end        datetime       not null comment '適用終了日時',
    created_at datetime       null comment '作成日時',
    updated_at datetime       not null comment '更新日時',
    deleted_at datetime       null comment '削除日時'
);

create table item
(
    id          mediumint unsigned auto_increment
        primary key,
    name        varchar(1024)      not null comment '商品名',
    description text               not null comment '商品の説明',
    kind_id     mediumint unsigned not null comment '商品のカテゴリ(別テーブルのIDを指定)',
    price       mediumint unsigned not null comment '標準価格(税抜)',
    tax_id      tinyint unsigned   not null comment '税率適用ID',
    created_at  datetime           null comment '作成日時',
    updated_at  datetime           not null comment '更新日時',
    deleted_at  datetime           null comment '削除日時',
    constraint item_item_kind_id_fk
        foreign key (kind_id) references item_kind (id),
    constraint item_tax_id_fk
        foreign key (tax_id) references tax (id)
);

create table inventory
(
    id          mediumint unsigned auto_increment
        primary key,
    item_id     mediumint unsigned not null comment '商品ID',
    stock_count mediumint unsigned not null comment '在庫数',
    start       datetime           not null comment '取り扱い開始日時',
    end         datetime           not null comment '取り扱い終了日',
    created_at  datetime           null comment '作成日時',
    updated_at  datetime           not null comment '更新日時',
    deleted_at  datetime           null comment '削除日時',
    constraint inventory_item_id_fk
        foreign key (item_id) references item (id)
)
    comment '在庫';

create table orders_detail
(
    id              int unsigned auto_increment
        primary key,
    order_id        int unsigned       not null comment '注文番号',
    order_id_branch tinyint unsigned   not null comment '注文詳細番号(商品ごとに枝番を生成)',
    item_id         mediumint unsigned not null comment '商品ID',
    count           mediumint unsigned not null comment '商品個数',
    constraint orders_detail_pk
        unique (order_id_branch),
    constraint orders_detail_item_id_fk
        foreign key (item_id) references item (id),
    constraint orders_detail_item_id_fk2
        foreign key (item_id) references item (id)
)
    comment '　';

