## Evidence

----------------------------------------------------
|                 DescribeInstances                |
+----------------------+----------+----------------+
|  i-05061a8ce714f4449 |  running |  35.93.15.196  |
+----------------------+----------+----------------+


## API Tests

**GET /health**

curl http://35.93.15.196:8080/health

```bash
{"status":"ok","compute":"ec2"}
```

**POST /echo**

curl -X POST http://35.93.15.196:8080/echo -H 'Content-Type: application/json' -d '{"msg":"hello"}'

```bash
{"msg":"hello","compute":"ec2"}
```