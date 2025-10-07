package com.snaplingua.backend

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HelloController {

    @GetMapping("/")
    fun home(): String {
        return "SnapLingua Backend is running successfully!"
    }

    @GetMapping("/hello")
    fun hello(): String {
        return "Hello from SnapLingua!"
    }

    @GetMapping("/health")
    fun health(): Map<String, String> {
        return mapOf(
            "status" to "UP",
            "service" to "SnapLingua Backend",
            "version" to "1.0.0"
        )
    }
}