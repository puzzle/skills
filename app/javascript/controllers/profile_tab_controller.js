import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['tab']

    connect() {
        this.setCurrentTab()
    }
    
    setCurrentTab() {
        this.tabTargets.forEach((element) => element.classList.remove('active'))
        this.tabTargets.forEach((element) => this.isCorrectTab(element) ? element.classList.add('active') : null)
    }

    isCorrectTab(currentTab) {
        const currentTabPath = currentTab.parentElement.getAttribute('href');
        const currentPath =  window.location.pathname
        return currentTabPath === currentPath
    }
}