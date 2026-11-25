package com.example.unigearmanager

import android.util.Patterns

object AuthRules {
    private val userIdPattern = Regex("^[A-Za-z0-9_-]{6,20}$")
    private val studentIdPattern = Regex("^[0-9]{2}-[0-9]{4}$")

    fun userIdError(value: String, label: String): String? {
        return when {
            value.isBlank() -> "$label is required"
            value.length !in 6..20 -> "$label must be 6 to 20 characters"
            !userIdPattern.matches(value) -> "$label can use letters, numbers, _ or - only"
            else -> null
        }
    }

    fun studentIdError(value: String): String? {
        return when {
            value.isBlank() -> "Student ID is required"
            !studentIdPattern.matches(value) ->
                "Student ID must use the format NN-NNNN (e.g. 24-0177)"
            else -> null
        }
    }

    fun emailError(value: String): String? {
        return when {
            value.isBlank() -> "Email address is required"
            value.length > 254 -> "Email must be 254 characters or less"
            !Patterns.EMAIL_ADDRESS.matcher(value).matches() -> "Enter a valid email address"
            else -> null
        }
    }

    fun passwordError(value: String): String? {
        return when {
            value.isEmpty() -> "Password is required"
            value.length < 12 -> "Password must be at least 12 characters"
            value.length > 64 -> "Password must be 64 characters or less"
            else -> null
        }
    }
}
