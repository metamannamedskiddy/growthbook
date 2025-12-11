FROM node:18-bullseye AS builder

WORKDIR /app

COPY package.json yarn.lock ./
COPY packages/back-end ./packages/back-end

RUN yarn install --frozen-lockfile
RUN yarn workspace @growthbook/back-end build

FROM node:18-bullseye

WORKDIR /app

COPY package.json yarn.lock ./
COPY --from=builder /app/packages/back-end ./packages/back-end

RUN yarn install --production --frozen-lockfile

ENV PORT=3000
EXPOSE 3000

CMD ["yarn", "workspace", "@growthbook/back-end", "start"]
