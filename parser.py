import yaml

rolesData = open('roles.yml', 'r').read()
roles = yaml.load(rolesData)

for role in roles['roles']:
  print("{0}\t{1}".format(role['name'], role['url']))
