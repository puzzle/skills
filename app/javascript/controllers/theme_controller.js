import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const theme = this.getCookieValue()

        if (theme === "dark") {
            this.enableThemeDark()
        } else {
            this.enableThemeLight()
        }
    }

    enableThemeDark() {
        this.setCookieValue('dark')
        document.documentElement.classList.add('theme-dark')
    }

    enableThemeLight() {
        this.setCookieValue('light')
        document.documentElement.classList.remove('theme-dark')
    }

    toggle() {
        if (document.documentElement.classList.contains("theme-dark")) {
            this.enableThemeLight()
        } else {
            this.enableThemeDark()
        }
    }

    setCookieValue(value) {
        document.cookie = `theme=${value}; path=/; max-age=31536000; SameSite=Lax`
    }

    getCookieValue() {
        return document.cookie
            .split("; ")
            .find((row) => row.startsWith("theme="))
            ?.split("=")[1]
    }


}