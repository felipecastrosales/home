package com.felipecastrosales.home

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import java.io.File
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class NewsWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.news_widget).apply {

                val title = widgetData.getString("headline_title", null)
                setTextViewText(R.id.headline_title, title ?: "No title set")

                val description = widgetData.getString("headline_description", null)
                setTextViewText(R.id.headline_description, description ?: "No description set")

                val imageName = widgetData.getString("filename", null)
                val imageFile = File(context.filesDir, imageName ?: "no_image")
                val imageExists = imageFile.exists()
                if (imageExists) {
                    val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                    setImageViewBitmap(R.id.widget_image, myBitmap)
                } else {
                    println("image not found!, looked @: ${imageFile.absolutePath}")
                }
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}