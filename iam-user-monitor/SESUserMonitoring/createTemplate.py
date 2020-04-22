import boto3

TEMPLATE_NAME='User_Console_Login_Monitoring'
SUBJECT_PART='User Console Login Monitoring'
HTML_PART='<!DOCTYPE html><html><head><style>table{font-family:arial,sans-serif;border-collapse:collapse;width:100%}td,th{border:1px solid #ddd;text-align:left;padding:8px}tr:nth-child(even){background-color:#ddd}</style></head><body><h2>Hello AWS Cloud Admin</h2><p>Here is a list of the users who have had console login access</p><table><tr><th>User</th><th>Last Sign In</th><th>Created</th></tr>{{#each data}}<tr><td>{{ username }}</td><td>{{ lastSignIn }}</td><td>{{ createDate }}</td></tr>{{/each}}</table></body></html>'
TEXT_PART='Hello AWS Cloud Admin\n\nHere is a list of the users who have had console login access:\n{{#each data}}- {{username}} - {{lastSignIn}} - {{ createDate }}\n{{/each}}'

ses = boto3.client('ses')
responseTemplate = ses.create_template(
    Template={
        'TemplateName': TEMPLATE_NAME,
        'SubjectPart': SUBJECT_PART,
        'HtmlPart': HTML_PART,
        'TextPart': TEXT_PART
    }
)
