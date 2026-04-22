package com.test.jesiyo.location.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LocationController {

	@GetMapping("/map")
	public String map() {

		return "/locations/mapTest";
	}
}
