package com.pbfw.common.schedule;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketMessageBrokerConfig extends AbstractWebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/stomp")
		.setAllowedOrigins("*")
//		.setAllowedOrigins("http://192.168.0.4:8080")
//		.setAllowedOrigins("http://211.251.237.150:9080")
		.withSockJS();
//		.setStreamBytesLimit(512 * 1024)
//		.setHttpMessageCacheSize(1000)
//		.setDisconnectDelay(30 * 1000);
	}

	
	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		registry.setApplicationDestinationPrefixes("/app");
		registry.enableSimpleBroker("/subscribe", "/topic");
	}

}
