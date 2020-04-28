import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from_addr = "cheese@factory.ai" # NEEDED
target_addr = "iamareceiver@blah.ai' # NEEDED

async def send_mail_to():
    smtp = smtplib.SMTP('smtp.server.com') # NEEDED 

    msg = MIMEMultipart()
    msg['Subject'] = 'This is the subject' # NEEDED  
    msg["From"] = from_addr
    msg["To"] = target_addr
    
    part = MIMEText("Hello this is the content you want to send") # NEEDED 
    msg.attach(part)
    smtp.sendmail(from_addr, target_addr, msg.as_string())
    smtp.quit()
    return "sent"
