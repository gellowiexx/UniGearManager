package com.example.unigearmanager

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class AuthRulesTest {
    @Test
    fun studentIdError_acceptsExpectedFormat() {
        assertNull(AuthRules.studentIdError("24-0177"))
    }

    @Test
    fun studentIdError_rejectsIncorrectFormats() {
        listOf("", "2-0177", "24-177", "24-01A7", "24_0177").forEach { value ->
            assertEquals(
                if (value.isBlank()) "Student ID is required"
                else "Student ID must use the format NN-NNNN (e.g. 24-0177)",
                AuthRules.studentIdError(value)
            )
        }
    }
}
