nginx: {
    # Basic nginx http settings, place this in http section
    basic = ''
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;

        include ${nginx}/conf/mime.types;
        default_type application/octet-stream;

        gzip on;
        gzip_disable "msie6";
    '';

    # Add required cors headers, place this in location section
    cors =
    let
      corsHeaders = ''
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Credentials' 'true';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,userid';
      '';
    in ''
        if ($request_method = 'OPTIONS') {
            ${corsHeaders}

            #
            # Tell client that this pre-flight info is valid for 20 days
            #

            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain charset=UTF-8';
            add_header 'Content-Length' 0;

            return 204;
        }

        if ($request_method = 'GET') {
            ${corsHeaders}
        }

        if ($request_method = 'POST') {
            ${corsHeaders}
        }

        if ($request_method = 'PUT') {
            ${corsHeaders}
        }
    '';

    # Json logging format, place this in http section
    logjson = ''
          log_format json '{ "server": "$scheme://$server_name:$server_port", '
                            '"remote_addr": "$remote_addr", '
                            '"remote_user": "$remote_user", '
                            '"body_bytes_sent": "$body_bytes_sent", '
                            '"request_time": "$request_time", '
                            '"status": "$status", '
                            '"request": "$request", '
                            '"request_method": "$request_method", '
                            '"http_referrer": "$http_referer", '
                            '"http_user_agent": "$http_user_agent" }';
    '';
}
