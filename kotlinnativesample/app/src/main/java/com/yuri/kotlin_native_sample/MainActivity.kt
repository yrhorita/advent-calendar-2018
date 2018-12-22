package com.yuri.kotlin_native_sample

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val api = ApplicationApi()
        val mapper = jacksonObjectMapper().disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)

        api.about {
            GlobalScope.apply {
                launch(Dispatchers.Main) {
                    print(it)
                    println("hello")
                    val parsed = mapper.readValue<Response>(it)
                    parsed.hits.forEach {
                        println(it)
                    }
                }
            }
        }
        findViewById<TextView>(R.id.main_text).text = createApplicationScreenMessage()
    }
}
