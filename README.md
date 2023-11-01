# オンラインショップ schema


## Troubleshooting

```text
Wed Nov 01 02:21:22 GMT 2023 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
WARN  - Connection Failure
Failed to connect to database URL [jdbc:mysql://localhost:64919/online_shop] Communications link failure
```



```text
WARN  - Connection Failure
Failed to connect to database URL [jdbc:mysql://localhost:64919/online_shop] Unable to load authentication plugin 'caching_sha2_password'.
```

solve

```shell
ALTER USER 'ユーザー名'@'localhost' IDENTIFIED WITH mysql_native_password BY 'パスワード';
```
