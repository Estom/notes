function calculateDaysBetweenDates(begin, end) {    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    const firstDate = new Date(begin);
    const secondDate = new Date(end);

    const diffDays = Math.round(Math.abs((firstDate - secondDate) / oneDay));
    return diffDays;
}

function testThis() {
    console.log(this); // logs the value of "this" in the current context
}

// Example usage:
testThis(); // logs the global object (e.g. "window" in a browser)
const obj = { name: "GitHub Copilot" };
obj.testThis = testThis;
obj.testThis(); // logs the "obj" object
