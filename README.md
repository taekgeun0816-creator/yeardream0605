# Yeardream 2026 May

Python 3.12 데이터 분석 환경

---

## 시작하기

### 1. uv 설치 (처음 한 번만)

**Windows (PowerShell)**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. 라이브러리 설치

```bash
uv sync
```

### 3. 실행 방법

**라이브러리 버전 확인**
```bash
uv run python check_env.py
```

**JupyterLab 실행**
```bash
uv run jupyter lab
```

---

## 포함된 라이브러리

| 용도 | 라이브러리 |
|------|-----------|
| 수치 연산 | numpy, scipy |
| 데이터 처리 | pandas, pyarrow |
| 시각화 | matplotlib, seaborn, plotly |
| 머신러닝 | scikit-learn, statsmodels |
| 파일 입출력 | openpyxl, xlrd |
| 개발 도구 | jupyterlab, ipykernel |

---

## 폴더 구조

```
yeardream2026_May/
├── check_env.py      ← 라이브러리 버전 확인
├── notebooks/        ← Jupyter 노트북 저장
├── data/             ← 데이터 파일
├── pyproject.toml    ← 라이브러리 목록
└── uv.lock           ← 버전 고정 파일 (건드리지 마세요)
```
