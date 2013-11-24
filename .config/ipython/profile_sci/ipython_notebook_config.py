c = get_config()

# Kernel config
c.IPKernelApp.pylab = 'inline'

# Notebook config
#c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/mycert.pem'
#c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = True
#c.NotebookApp.password = u'sha1:cf3fc87e49121b8ba30a92a1278dc89512681ef0'
# It's a good idea to put it on a known, fixed port
c.NotebookApp.port = 9999
