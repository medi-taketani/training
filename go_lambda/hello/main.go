package main
 
import (
  "fmt"
  "os"
  "crypto/hmac"
  "crypto/sha256"
  "encoding/hex"
  "encoding/base64"
  "net/http"

  "github.com/aws/aws-lambda-go/events"
  "github.com/aws/aws-lambda-go/lambda"
)
 
func handle(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
  err := veryfySig()
  if err != nil {
    fmt.Println("veryfy error: ", err)

    return events.APIGatewayProxyResponse{
      Body:       "veryfy error",
      StatusCode: 400,
    }, nil
  }

  err = requestAPI()
  if err != nil {
    fmt.Println("request error: ", err)
  }

  return events.APIGatewayProxyResponse{
    Body:       "OK",
    StatusCode: 200,
  }, nil
}
 
func main() {
  lambda.Start(handle)
}

func veryfySig() error {
  timestamp := request.Headers["X-Slack-Request-Timestamp"]
  headerSig := request.Headers["X-Slack-Signature"]

  mySig := os.Getenv("SLACK_SIGN")

  decoded, err := base64.StdEncoding.DecodeString(request.Body)
  if err != nil {
    fmt.Println("decode error:", err)
  }
  fmt.Println("decoded: ", string(decoded))

  baseStr := "v0:" + timestamp + ":" + string(decoded)

  sigMy := makeHMAC(baseStr, mySig)

  fmt.Println("sigMy:",sigMy)
}

func makeHMAC(msg, key string) string {
  mac := hmac.New(sha256.New, []byte(key))
  mac.Write([]byte(msg))

  return hex.EncodeToString(mac.Sum(nil))
}

func requestAPI() error {
  url := os.Getenv("API_URL")

  reader := strings.NewReader('{"text":"Hello, World!"})
  http.POST(url, 'application/json', reader)

  return nil
}
