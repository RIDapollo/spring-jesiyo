package com.test.jesiyo.location.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LocationController {

	@GetMapping("/map")
	public String map() {

		return "/locations/mapTest";
	}
	
	@GetMapping("/locations/new")
	public String mapAddr() {
		
		return "/locations/member-location";
	}
	
}
