const config = {

    development: {
      greetifyValidatorServiceUrl: process.env.GREETIFY_VALIDATOR_URL || "http://greetify-validator:5194",
      appVersion: process.env.APP_VERSION || "v1"
    }
};
  
const serviceConfig = config[process.env.NODE_ENV || "development"];
  
export {
    serviceConfig
}
  