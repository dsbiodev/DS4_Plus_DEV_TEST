package com.pbfw.common.util;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class MailUtil {
	private Logger log = LoggerFactory.getLogger(this.getClass());
	private String adminMail = "";
	private String adminPassword = "";
	
	Authenticator auth = null;
	Session session = null;
	
	public MailUtil() {
		Properties prop = System.getProperties();
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.host", "smtp.gmail.com");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.port", "587");	// TLS:587, SSL:465
		
		auth = new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(adminMail, adminPassword);
			}
		};
		
		session = Session.getDefaultInstance(prop, auth);
	}
	
	public Integer mailSender(HashMap<String, Object> mailMap) {
		MimeMessage msg = new MimeMessage(session);
		
		try {
			msg.setSentDate(new Date());
			
			InternetAddress from = new InternetAddress(adminMail, "SOOM");
			InternetAddress to = new InternetAddress(mailMap.get("to").toString());
			
			msg.setFrom(from);
			msg.setRecipient(Message.RecipientType.TO, to);
//			msg.setRecipient(Message.RecipientType.CC, cc);		// 참조
//			msg.setRecipient(Message.RecipientType.BCC, bcc);	// 숨은 참조
			msg.setSubject(mailMap.get("title").toString(), "UTF-8");
			msg.setText(mailMap.get("text").toString(), "UTF-8");
			Transport.send(msg);
			
			log.debug("Mail Send Complete.");
			return 1;
		} catch(AddressException ae) {
			log.debug("AddressException : " + ae.getMessage());
			return 0;
		} catch(MessagingException me) {
			log.debug("MessagingException : " + me.getMessage());
			return 0;
		} catch(UnsupportedEncodingException e) {
			log.debug("UnsupportedEncodingException : " + e.getMessage());
			return 0;
		}
	}
}