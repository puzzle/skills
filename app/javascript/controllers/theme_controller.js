import {Controller} from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
    connect() {
        const theme = this.getCookieValue();

        this.changeTheme(theme)

        this.element.value = theme

        this.select = new SlimSelect({
            select: this.element,
            settings: {
                showSearch: false,
            },
            events: {
                afterChange: (newVal) => {
                    const selectedTheme = newVal[0].value

                    this.changeTheme(selectedTheme)
                }
            }
        })
    }

    disconnect() {
        if (this.select) {
            this.select.destroy()
        }
    }

    changeTheme(theme) {
        switch(theme) {
            case "dark":
                this.enableThemeDark();
                break;
            case "light":
                this.enableThemeLight();
                break;
            case "system":
                this.enableThemeSystem();
                break;
            default:
                this.enableThemeLight();
                break;
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

    enableThemeSystem() {
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            this.enableThemeDark();
        } else {
            this.enableThemeLight();
        }
        this.setCookieValue('system')
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