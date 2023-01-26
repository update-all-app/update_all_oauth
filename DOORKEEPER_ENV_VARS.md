Run 
```
rails db:seed
```

Then you should see someting like this in the terminal

```text
Add the following to your .env file
REACT_CLIENT_UID=Whzs8PZa1Y2Ta0UjGIerkGkjiFHPm_6nD2bUotJ6T_w
REACT_CLIENT_SECRET=OKXeWRwerXOmI8-6LhWDAkFEQb50sqL5WMaRWHb_KEU
```

Add those two lines to your .env file and doorkeeper should be ready to go to support authentication via the client side dev server.