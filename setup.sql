-- create schema online shop
create schema online;

create table if not exists item_kind
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

create table if not exists payment_method
(
    id   tinyint unsigned auto_increment
        primary key,
    name varchar(8) null comment '決済方法'
)
    comment '決済方法';

create table if not exists orders
(
    id             mediumint unsigned auto_increment
        primary key,
    item_id        mediumint unsigned not null comment '商品ID',
    customer_id    mediumint unsigned not null comment '顧客ID(注文してくれたお客さんを特定)',
    payment_method tinyint unsigned   not null comment '決済方法',
    payment_status mediumint unsigned not null comment '決済ステータス',
    delivery_usage tinyint unsigned   not null comment '配送方法',
    created_at     datetime           null comment '作成日時',
    updated_at     datetime           not null comment '更新日時',
    deleted_at     datetime           null comment '削除日時',
    constraint orders_payment_method_id_fk
        foreign key (payment_method) references payment_method (id)
);

create index orders_payment_status_id_fk
    on orders (payment_status);

create table if not exists prefecture
(
    code   tinyint unsigned not null comment '都道府県コード'
        primary key,
    name   varchar(4)       not null comment '都道府県名',
    ei_mei varchar(16)      not null comment '英語名'
)
    comment '都道府県コードを管理';

create table if not exists customers
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
    tel        varchar(16)      null comment '電話番号',
    constraint customers_prefecture_code_fk
        foreign key (province) references prefecture (code)
)
    comment '顧客(注文した人の情報を管理)';

create table if not exists tax
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

create table if not exists item
(
    id         mediumint unsigned auto_increment
        primary key,
    name       varchar(1024)      not null comment '商品名',
    detail     text               not null comment '商品の説明',
    kind       mediumint unsigned not null comment '商品のカテゴリ(別テーブルのIDを指定)',
    price      mediumint unsigned not null comment '標準価格(税抜)',
    tax_id     tinyint unsigned   not null comment '税率適用ID',
    created_at datetime           null comment '作成日時',
    updated_at datetime           not null comment '更新日時',
    deleted_at datetime           null comment '削除日時',
    constraint item_item_kind_id_fk
        foreign key (kind) references item_kind (id),
    constraint item_tax_id_fk
        foreign key (tax_id) references tax (id)
);

create table if not exists inventory
(
    id          mediumint unsigned auto_increment
        primary key,
    item_id     mediumint unsigned not null comment '商品ID',
    stock_cound mediumint unsigned not null comment '在庫数',
    start       datetime           not null comment '取り扱い開始日時',
    end         datetime           not null comment '取り扱い終了日',
    created_at  datetime           null comment '作成日時',
    updated_at  datetime           not null comment '更新日時',
    deleted_at  datetime           null comment '削除日時',
    constraint inventory_item_id_fk
        foreign key (item_id) references item (id)
)
    comment '在庫';

create table if not exists payment_status
(
    id       mediumint unsigned not null comment '決済ID'
        primary key,
    order_id mediumint unsigned null comment '対象の注文ID',
    status   tinyint unsigned   not null comment '現在のステータス',
    constraint payment_status_item_id_fk
        foreign key (order_id) references item (id)
)
    comment '決済ステータスを管理';


