import boto3

SAMPLE_TEMPLATE_NAME='User_Console_Login_Test3'
TEMPLATE_NAME='User_Console_Login_Monitoring'

FIRST_HTML_PART='<h1>Hello Admin</h1><p>This is an overview of the users who have had login in to the console:</p><ul> {{#each data}}<li>{{username}} - {{lastSignIn}}</li> {{/each}}</ul>'
HTML_PART='<!DOCTYPE html><html><head><style>table{font-family:arial,sans-serif;border-collapse:collapse;width:100%}td,th{border:1px solid #ddd;text-align:left;padding:8px}tr:nth-child(even){background-color:#ddd}</style></head><body><h2>Hello Admin</h2><p>Here is a list of the users who have had console login access</p><table><tr><th>User</th><th>Last Sign In</th><th>Created</th></tr>{{#each data}}<tr><td>{{ username }}</td><td>{{ lastSignIn }}</td><td>{{ createDate }}</td></tr>{{/each}}</table></body></html>'
SAMPLE_HTML_PART='<!DOCTYPE html><html><head><style>table{font-family:arial,sans-serif;border-collapse:collapse;width:100%}td,th{border:1px solid #ddd;text-align:left;padding:8px}tr:nth-child(even){background-color:#ddd}</style></head><body><h2>HTML Table</h2><table><tr><th>Company</th><th>Contact</th><th>Country</th></tr><tr><td>Alfreds Futterkiste</td><td>Maria Anders</td><td>Germany</td></tr><tr><td>Centro comercial Moctezuma</td><td>Francisco Chang</td><td>Mexico</td></tr><tr><td>Ernst Handel</td><td>Roland Mendel</td><td>Austria</td></tr><tr><td>Island Trading</td><td>Helen Bennett</td><td>UK</td></tr><tr><td>Laughing Bacchus Winecellars</td><td>Yoshi Tannamuri</td><td>Canada</td></tr><tr><td>Magazzini Alimentari Riuniti</td><td>Giovanni Rovelli</td><td>Italy</td></tr></table></body></html>'
# HTML_PART_T='<body><h2>Hello Admin</h2><p>Here is a list of the users who have had console login access</p><table><tr><th>User</th><th>Last Sign In</th><th>Created</th></tr><tr> {{#each data}}<td>{{ username }}</td><td>{{ lastSignIn }}</td><td>{{ createDate }}</td> {{/each}}</tr></table></body>'
HTML_PART_2='<h2>Hello Admin</h2><p>Here is a list of the users who have had console login access</p><table><tr><th>User</th><th>Last Sign In</th><th>Created</th></tr><tr> {{#each data}}<td>{{ username }}</td><td>{{ lastSignIn }}</td><td>{{ createDate }}</td> {{/each}}</tr></table>'

TEXT_PART='Hello Admin\n\nHere is a list of the users who have had console login access:\n{{#each data}}- {{username}} - {{lastSignIn}}\n{{/each}}'

SUBJECT_PART='User Console Login Monitoring'

ses = boto3.client('ses')
responseTemplate = ses.create_template(
    Template={
        'TemplateName': TEMPLATE_NAME,
        'SubjectPart': SUBJECT_PART,
        'HtmlPart': HTML_PART,
        'TextPart': TEXT_PART
    }
)
