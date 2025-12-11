FROM node:18-bullseye AS builder

WORKDIR /app

# Copy only backend package
COPY packages/back-end ./packages/back-end
COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile
RUN yarn workspace @growthbook/back-end build

# --- Runtime stage ---
FROM node:18-bullseye

WORKDIR /app

COPY --from=builder /app/packages/back-end ./packages/back-end
COPY package.json yarn.lock ./

RUN yarn install --production --frozen-lockfile

ENV PORT=3000
EXPOSE 3000

CMD ["yarn", "workspace", "@growthbook/back-end", "start"]
