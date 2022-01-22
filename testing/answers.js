import http from 'k6/http';
import { sleep } from 'k6';
export const options = {
  stages: [
    { duration: '30s', target: 1000 },
    { duration: '30s', target: 500 },
    { duration: '20s', target: 50 },
  ],
};
export default function () {
  http.get('http://localhost:3000/qa/questions/:question_id/answers');
  sleep(1);
}