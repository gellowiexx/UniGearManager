package com.example.unigearmanager

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout

class StaffLoginActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_staff_login)

        val backButton = findViewById<MaterialButton>(R.id.btnBackStaff)
        val staffIdInputLayout = findViewById<TextInputLayout>(R.id.staffIdInputLayout)
        val emailInputLayout = findViewById<TextInputLayout>(R.id.emailStaffInputLayout)
        val passwordInputLayout = findViewById<TextInputLayout>(R.id.passwordStaffInputLayout)
        val staffIdInput = findViewById<TextInputEditText>(R.id.staffIdInput)
        val emailInput = findViewById<TextInputEditText>(R.id.emailStaffInput)
        val passwordInput = findViewById<TextInputEditText>(R.id.passwordStaffInput)
        val loginButton = findViewById<MaterialButton>(R.id.btnStaffLoginSubmit)
        val supportLink = findViewById<TextView>(R.id.tvStaffSupport)

        backButton.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }

        loginButton.setOnClickListener {
            // Clear previous errors
            staffIdInputLayout.error = null
            emailInputLayout.error = null
            passwordInputLayout.error = null

            val staffId = staffIdInput.text?.toString()?.trim().orEmpty()
            val email = emailInput.text?.toString()?.trim().orEmpty()
            val password = passwordInput.text?.toString().orEmpty()

            var hasError = false
            AuthRules.userIdError(staffId, "Staff ID")?.let {
                staffIdInputLayout.error = it
                hasError = true
            }
            AuthRules.emailError(email)?.let {
                emailInputLayout.error = it
                hasError = true
            }
            AuthRules.passwordError(password)?.let {
                passwordInputLayout.error = it
                hasError = true
            }

            if (hasError) return@setOnClickListener

            Toast.makeText(this, "Welcome Staff! Accessing dashboard...", Toast.LENGTH_SHORT).show()
            startActivity(Intent(this, DashboardActivity::class.java))
            finish()
        }

        supportLink.setOnClickListener {
            Toast.makeText(this, "Contacting support team...", Toast.LENGTH_SHORT).show()
            // TODO: Navigate to support contact activity or send email
        }
    }
}

