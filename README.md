# Ngnix CORS Anywhere

Configure Nginx server as a reverse proxy so that inject header `Access-Control-Allow-Origin: '*'` on all responses.

In frontend development, requests from client side Javascript, such as axios.get(targetURL).then(...).catch(...), often 
receive `Failed to load <targetURL>: No 'Access-Control-Allow-Origin' header is present on the requested resource. 
Origin 'http://127.0.0.1:8080' is therefore not allowed access.`

This docker configure a Nginx server, such that when client sent request to `http://nginx-cors-server/cors/<targetURL>`,
the server proxy_pass and proxy_redirect the request to `<targetURL>`, and when the server receive the response from the
`<targetURL>`, the server add header `Access-Control-Allow-Origin: '*'` on the response, and pass it back to client.

Two upstream modes are supported and selected via the `CORS_MODE` environment variable (default: `dispatcher`):

- `dispatcher`: forward the request to the internal dispatcher service (`nginx-cors-worker.proxy:8080`), which is responsible for reaching the final destination.
- `client`: connect directly to the external host (enables SNI and IPv4-only DNS to avoid TLS/IPv6 handshake issues).

### Docker

```
$ docker build -t my/nginx-cors .

# dispatcher mode (default)
$ docker run --rm -it -p 80:80 -e CORS_MODE=dispatcher my/nginx-cors

# direct client mode
$ docker run --rm -it -p 80:80 -e CORS_MODE=client my/nginx-cors
```

### Deploy script

`docker.sh` now accepts a second parameter to tag images with the selected mode:

```
$ ./docker.sh v1 dispatcher   # builds ccr.ccs.tencentyun.com/doudou/nginx-cors-dispatcher:<tag>
$ ./docker.sh v1 client       # builds ccr.ccs.tencentyun.com/doudou/nginx-cors-client:<tag>
```

```
$ curl -H 'Origin: http://192.168.0.1' -I -X GET http://127.0.0.1/cors/https://www.google.com/

$ curl -H 'Origin: http://192.168.0.1' -I -X GET http://127.0.0.1/cors/https://www.google.com/ --verbose

# note: as above, nginx-cors-server is running on localhost, e.g., http://127.0.0.1/, and a request to targetURL 
# https://www.google.com/ is proxy_pass and proxy_redirect by nginx-cors-server, using 
# http://127.0.0.1/cors/https://www.google.com/.
```  
